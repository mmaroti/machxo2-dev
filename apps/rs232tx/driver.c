#include <libftdi1/ftdi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

const int INTERFACE = INTERFACE_B;
const int VENDOR = 0x0403;
const int PRODUCT = 0x6010;
const char* DESCRIPTION = "Lattice FTUSB Interface Cable";
// const int BAUDRATE = 115200;
const int BAUDRATE = 12000000;

int main(void)
{
    int ret;
    struct ftdi_context* ftdi;
    unsigned char buffer[256];
    unsigned short status;

    memset(buffer, 0, sizeof(buffer));

    if ((ftdi = ftdi_new()) == 0) {
        fprintf(stderr, "Could not initialiye FTDI\n");
        return EXIT_FAILURE;
    }

    printf("Setting FTDI interface to %d\n", INTERFACE);
    if ((ret = ftdi_set_interface(ftdi, INTERFACE)) < 0)
        goto error;

    printf("Opening FTDI device %04x:%04x %s\n", VENDOR, PRODUCT, DESCRIPTION);
    if ((ret = ftdi_usb_open_desc(ftdi, VENDOR, PRODUCT, DESCRIPTION, NULL)) < 0)
        goto error;

    printf("Reading EEPROM\n");
    if ((ret = ftdi_read_eeprom(ftdi)) < 0)
        goto error;

    printf("Decoding EEPROM\n");
    if ((ret = ftdi_eeprom_decode(ftdi, 1)) < 0)
        goto error;

    printf("Polling modem status\n");
    if ((ret = ftdi_poll_modem_status(ftdi, &status)) < 0)
        goto error;
    printf("Modem status 0x%04x\n", (int)status);

    printf("Setting baudrate to %d\n", BAUDRATE);
    if ((ret = ftdi_set_baudrate(ftdi, BAUDRATE)) < 0)
        goto error;

    printf("Setting line property to 8 bits 1 stopbit no parity\n");
    if ((ret = ftdi_set_line_property(ftdi, 8, STOP_BIT_1, NONE)) < 0)
        goto error;

    printf("Setting up RTS/CTS flow control\n");
    if ((ret = ftdi_setflowctrl(ftdi, SIO_RTS_CTS_HS)) < 0)
        goto error;

    // printf("Purging buffers\n");
    // if ((ret = ftdi_usb_purge_buffers(ftdi)) < 0)
    //  goto error;

    printf("Setting RTS to 1\n");
    if ((ret = ftdi_setrts(ftdi, 1)) < 0)
        goto error;

    // printf("Sleeping for 1 seconds\n");
    // sleep(1);

    printf("Setting RTS to 0\n");
    if ((ret = ftdi_setrts(ftdi, 0)) < 0)
        goto error;

    printf("Reading data\n");
    if ((ret = ftdi_read_data(ftdi, buffer, sizeof(buffer))) < 0)
        goto error;

    printf("Read %d bytes (0x%02x%02x%02x%02x)\n", ret, buffer[0], buffer[1],
        buffer[2], buffer[3]);

    if (0) {
        printf("Dumping data:");
        for (int i = 0; i < ret; i++) {
            if (i % 8 == 0)
                printf("\n%6d: ", i);
            for (int j = 0; j < 8; j++)
                printf("%c", (buffer[i] >> j) & 1 == 1 ? '1' : '0');
            printf(" ");
        }
        printf("\n");
    } else {
        printf("Dumping data:");
        for (int i = 0; i < ret; i++) {
            if (i % 16 == 0)
                printf("\n%6d:", i);
            printf(" 0x%02x", buffer[i]);
        }
        printf("\n");
    }

    for (int i = 1; i < sizeof(buffer); i++) {
        if ((unsigned char)(buffer[i] - buffer[i - 1]) != 1) {
            printf("Break in increasing sequence: 0x%02x 0x%02x\n", buffer[i - 1],
                buffer[i]);
            break;
        }
    }

    printf("Polling modem status\n");
    if ((ret = ftdi_poll_modem_status(ftdi, &status)) < 0)
        goto error;
    printf("Modem status 0x%04x\n", (int)status);

    printf("Closing FTDI device\n");
    if ((ret = ftdi_usb_close(ftdi)) < 0)
        goto error;

    ftdi_free(ftdi);
    return EXIT_SUCCESS;

error:
    fprintf(stderr, "FTDI error: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
    ftdi_free(ftdi);
    return EXIT_FAILURE;
}
