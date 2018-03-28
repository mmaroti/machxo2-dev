#include <libftdi1/ftdi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

const int INTERFACE = INTERFACE_B;
const int VENDOR = 0x0403;
const int PRODUCT = 0x6010;
const char* DESCRIPTION = "Lattice FTUSB Interface Cable";
// const int BAUDRATE = 115200;
const int BAUDRATE = 12000000;

struct ftdi_context* ftdi = NULL;
unsigned char buffer[1024 * 8];

void myftdi_verify(int ret)
{
    if (ret >= 0)
        return;

    fprintf(stderr, "FTDI error: %d (%s)\n", ret,
        ftdi != NULL ? ftdi_get_error_string(ftdi) : "unknown");

    ftdi_free(ftdi);
    exit(EXIT_FAILURE);
}

void myftdi_open_rs232()
{
    unsigned short status;

    if (ftdi != NULL) {
        fprintf(stderr, "Error: FTDI is already initialized\n");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ftdi = ftdi_new();
    if (ftdi == NULL) {
        fprintf(stderr, "Error: could not initialize FTDI\n");
        exit(EXIT_FAILURE);
    }

    printf("Setting FTDI interface to %d\n", INTERFACE);
    myftdi_verify(ftdi_set_interface(ftdi, INTERFACE));

    printf("Opening FTDI device %04x:%04x %s\n", VENDOR, PRODUCT, DESCRIPTION);
    myftdi_verify(ftdi_usb_open_desc(ftdi, VENDOR, PRODUCT, DESCRIPTION, NULL));

    if (0) {
        printf("Reading EEPROM\n");
        myftdi_verify(ftdi_read_eeprom(ftdi));

        printf("Decoding EEPROM\n");
        myftdi_verify(ftdi_eeprom_decode(ftdi, 1));
    }

    // printf("Polling modem status\n");
    myftdi_verify(ftdi_poll_modem_status(ftdi, &status));
    printf("Modem status 0x%04x\n", (int)status);

    printf("Setting baudrate to %d\n", BAUDRATE);
    myftdi_verify(ftdi_set_baudrate(ftdi, BAUDRATE));

    printf("Setting line property to 8 bits 1 stopbit no parity\n");
    myftdi_verify(ftdi_set_line_property(ftdi, 8, STOP_BIT_1, NONE));

    printf("Setting up RTS/CTS flow control\n");
    myftdi_verify(ftdi_setflowctrl(ftdi, SIO_RTS_CTS_HS));

    if (0) {
        printf("Purging buffers\n");
        myftdi_verify(ftdi_usb_purge_buffers(ftdi));
    }
}

void myftdi_close()
{
    unsigned short status;

    if (ftdi == NULL) {
        fprintf(stderr, "Error: FTDI is not initialized\n");
        exit(EXIT_FAILURE);
    }

    // printf("Polling modem status\n");
    myftdi_verify(ftdi_poll_modem_status(ftdi, &status));
    printf("Modem status 0x%04x\n", (int)status);

    printf("Closing FTDI device\n");
    myftdi_verify(ftdi_usb_close(ftdi));

    ftdi_free(ftdi);
    ftdi = NULL;
}

void myftdi_setrts(int value)
{
    printf("Setting RTS to %d\n", value);
    myftdi_verify(ftdi_setrts(ftdi, value));
}

double gettime()
{
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    return (double)ts.tv_sec + ts.tv_nsec * 1e-9;
}

void myftdi_read(int dumping)
{
    int ret;
    double ts = gettime();

    // printf("Reading data\n");
    myftdi_verify(ret = ftdi_read_data(ftdi, buffer, sizeof(buffer)));

    ts = gettime() - ts;
    printf("Read %d bytes (0x%02x%02x%02x%02x) in %f seconds\n",
        ret, buffer[0], buffer[1], buffer[2], buffer[3], ts);

    if (dumping == 1) {
        printf("Dumping data:");
        for (int i = 0; i < ret; i++) {
            if (i % 8 == 0)
                printf("\n%6d: ", i);
            for (int j = 0; j < 8; j++)
                printf("%c", (buffer[i] >> j) & 1 == 1 ? '1' : '0');
            printf(" ");
        }
        printf("\n");
    } else if (dumping == 2) {
        printf("Dumping data:");
        for (int i = 0; i < ret; i++) {
            if (i % 16 == 0)
                printf("\n%6d:", i);
            printf(" 0x%02x", buffer[i]);
        }
        printf("\n");
    } else if (dumping == 3) {
        for (int i = 1; i < ret; i++) {
            if ((unsigned char)(buffer[i] - buffer[i - 1]) != 1) {
                printf("Break in increasing sequence: 0x%02x 0x%02x\n", buffer[i - 1],
                    buffer[i]);
                break;
            }
        }
    }
}

void myftdi_write(int length)
{
    int ret;

    if (length > sizeof(buffer))
        length = sizeof(buffer);

    for (int i = 0; i < length; i++)
        buffer[i] = i;

    double ts = gettime();

    // printf("Writing data\n");
    myftdi_verify(ret = ftdi_write_data(ftdi, buffer, length));

    ts = gettime() - ts;
    printf("Written %d bytes in %f seconds\n", ret, ts);
}

void myftdi_sleep()
{
    printf("Sleeping for 1 seconds\n");
    sleep(1);
}

void myftdi_block_write(int block_size)
{
    if (block_size > sizeof(buffer))
        block_size = sizeof(buffer);

    for (int i = 0; i < block_size; i++)
        buffer[i] = i;

    int ret;
    myftdi_verify(ret = ftdi_write_data(ftdi, buffer, block_size));

    if (ret != block_size) {
        fprintf(stderr, "Error: could not write all\n");
        exit(EXIT_FAILURE);
    }
}

void myftdi_block_read(int block_size)
{
    if (block_size > sizeof(buffer))
        block_size = sizeof(buffer);

    int ret;
    myftdi_verify(ret = ftdi_read_data(ftdi, buffer, block_size));

    if (ret != block_size) {
        fprintf(stderr, "Error: could not read all\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < block_size; i++)
        if (buffer[i] != (unsigned char)(~i)) {
            printf("Error: incorrect byte is read\n");
            exit(EXIT_FAILURE);
        }
}

int main(void)
{
    myftdi_open_rs232();

    double ts = gettime();
    int block_count = 2000;
    int block_size = 1024;

    myftdi_block_write(block_size);
    myftdi_setrts(1);
    // myftdi_sleep();

    for (int i = 1; i < block_count; i++) {
        myftdi_block_write(block_size);
        myftdi_block_read(block_size);
    }
    myftdi_block_read(block_size);

    ts = gettime() - ts;
    printf("Loopback %d * %d = %d bytes in %.3f seconds (%.3f bytes/sec)\n",
        block_count, block_size, block_count * block_size, ts,
        block_count * block_size / ts);

    myftdi_setrts(0);
    myftdi_close();
    return EXIT_SUCCESS;
}
