dnl
dnl  $Id$
dnl

AC_DEFUN([AC_PREFIX_BLUEZ], [
	AC_PREFIX_DEFAULT(/usr)

	if test "$prefix" = "NONE"; then
		dnl no prefix and no sysconfdir, so default to /etc
		if test "$sysconfdir" = '${prefix}/etc'; then
			AC_SUBST([sysconfdir], ['/etc'])
		fi

		dnl no prefix and no mandir, so use ${prefix}/share/man as default
		if test "$mandir" = '${prefix}/man'; then
			AC_SUBST([mandir], ['${prefix}/share/man'])
		fi

		bluez_prefix="$ac_default_prefix"
	else
		bluez_prefix="$prefix"
	fi
])

AC_DEFUN([AC_PATH_BLUEZ], [
	AC_ARG_WITH(bluez, [  --with-bluez=DIR        BlueZ library is installed in DIR], [
		if (test "$withval" = "yes"); then
			bluez_includes=$bluez_prefix/include
			bluez_libraries=$bluez_prefix/lib
		else
			bluez_includes=$withval/include
			bluez_libraries=$withval/lib
		fi
	])

	BLUEZ_INCLUDES=""
	BLUEZ_LDFLAGS=""
	BLUEZ_LIBS=""

	ac_save_CFLAGS=$CFLAGS
	test -n "$bluez_includes" && CFLAGS="$CFLAGS -I$bluez_includes"

	ac_save_LDFLAGS=$LDFLAGS
	test -n "$bluez_libraries" && LDFLAGS="$LDFLAGS -L$bluez_libraries"

	AC_CHECK_HEADER(bluetooth/bluetooth.h,,
		AC_MSG_ERROR(Bluetooth header files not found))

	AC_CHECK_LIB(bluetooth, hci_open_dev,
		BLUEZ_LIBS="$BLUEZ_LIBS -lbluetooth",
		AC_MSG_ERROR(Bluetooth library not found))

	AC_CHECK_LIB(sdp, sdp_connect,
		BLUEZ_LIBS="$BLUEZ_LIBS -lsdp")

	CFLAGS=$ac_save_CFLAGS
	test -n "$bluez_includes" && BLUEZ_INCLUDES="-I$bluez_includes"

	LDFLAGS=$ac_save_LDFLAGS
	test -n "$bluez_libraries" && BLUEZ_LDFLAGS="-L$bluez_libraries"
	test -n "$bluez_libraries" && BLUEZ_LIBS="-L$bluez_libraries $BLUEZ_LIBS"

	AC_SUBST(BLUEZ_INCLUDES)
	AC_SUBST(BLUEZ_LDFLAGS)
	AC_SUBST(BLUEZ_LIBS)
])

AC_DEFUN([AC_PATH_USB], [
	AC_ARG_WITH(usb, [  --with-usb=DIR          USB library is installed in DIR], [
		if (test "$withval" = "yes"); then
			usb_includes=/usr/include
			usb_libraries=/usr/lib
		else
			usb_includes=$withval/include
			usb_libraries=$withval/lib
		fi
	])

	USB_INCLUDES=""
	USB_LDFLAGS=""
	USB_LIBS=""

	ac_save_CFLAGS=$CFLAGS
	test -n "$usb_includes" && CFLAGS="$CFLAGS -I$usb_includes"

	ac_save_LDFLAGS=$LDFLAGS
	test -n "$usb_libraries" && LDFLAGS="$LDFLAGS -L$usb_libraries"

	AC_CHECK_HEADER(usb.h,,
		AC_MSG_ERROR(USB header files not found))

	AC_CHECK_LIB(usb, usb_open,
		USB_LIBS="$USB_LIBS -lusb",
		AC_MSG_ERROR(USB library not found))

	CFLAGS=$ac_save_CFLAGS
	test -n "$usb_includes" && USB_INCLUDES="-I$usb_includes"

	LDFLAGS=$ac_save_LDFLAGS
	test -n "$usb_libraries" && USB_LDFLAGS="-L$usb_libraries"
	test -n "$usb_libraries" && USB_LIBS="-L$usb_libraries $USB_LIBS"

	AC_SUBST(USB_INCLUDES)
	AC_SUBST(USB_LDFLAGS)
	AC_SUBST(USB_LIBS)
])

AC_DEFUN([AC_PATH_DBUS], [
	AC_ARG_ENABLE(dbus, [  --enable-dbus           enable D-BUS support], [
		dbus_enable=$enableval
	])

	AC_ARG_WITH(dbus, [  --with-dbus=DIR         D-BUS library is installed in DIR], [
		if (test "$withval" = "yes"); then
			dbus_includes=$bluez_prefix/include
			dbus_libraries=$bluez_prefix/lib
		else
			dbus_includes=$withval/include
			dbus_libraries=$withval/lib
		fi
		dbus_enable=yes
	])

	DBUS_INCLUDES=""
	DBUS_LDFLAGS=""
	DBUS_LIBS=""

	ac_save_CFLAGS=$CFLAGS
	if test -n "$dbus_includes"; then 
		CFLAGS="$CFLAGS -I$dbus_includes -I$dbus_includes/dbus-1.0"
	else
		CFLAGS="$CFLAGS -I$bluez_prefix/include/dbus-1.0 -I/usr/include/dbus-1.0"
	fi
	CFLAGS="$CFLAGS -DDBUS_API_SUBJECT_TO_CHANGE"

	ac_save_LDFLAGS=$LDFLAGS
	if test -n "$dbus_libraries"; then
		CFLAGS="$CFLAGS -I$dbus_libraries/dbus-1.0/include"
		LDFLAGS="$LDFLAGS -L$dbus_libraries"
	else
		CFLAGS="$CFLAGS -I$bluez_prefix/include/dbus-1.0 -I/usr/lib/dbus-1.0/include"
	fi

	if test "$dbus_enable" = "yes"; then
		AC_CHECK_HEADER(dbus/dbus.h,,
			dbus_enable=no)

		AC_CHECK_LIB(dbus-1, dbus_error_init,
			DBUS_LIBS="$DBUS_LIBS -ldbus-1",
			dbus_enable=no)
	fi

	CFLAGS=$ac_save_CFLAGS
	if test -n "$dbus_includes"; then
		DBUS_INCLUDES="-I$dbus_includes -I$dbus_includes/dbus-1.0"
	else
		DBUS_INCLUDES="-I$bluez_prefix/include/dbus-1.0 -I/usr/include/dbus-1.0"
	fi

	LDFLAGS=$ac_save_LDFLAGS
	if test -n "$dbus_libraries"; then
		DBUS_INCLUDES="$DBUS_INCLUDES -I$dbus_libraries/dbus-1.0/include"
		DBUS_LDFLAGS="-L$dbus_libraries"
		DBUS_LIBS="-L$dbus_libraries $DBUS_LIBS"
	else
		DBUS_INCLUDES="$DBUS_INCLUDES -I$bluez_prefix/include/dbus-1.0 -I/usr/lib/dbus-1.0/include"
	fi

	AC_SUBST(DBUS_INCLUDES)
	AC_SUBST(DBUS_LDFLAGS)
	AC_SUBST(DBUS_LIBS)

	AM_CONDITIONAL(DBUS, test "$dbus_enable" = "yes")
])

AC_DEFUN([AC_PATH_CUPS], [
	AC_ARG_ENABLE(cups, [  --enable-cups           enable CUPS support], [
		cups_enable=$enableval
		cups_prefix=/usr
	])

	AC_ARG_WITH(cups, [  --with-cups=DIR         CUPS is installed in DIR], [
		if (test "$withval" = "yes"); then
			cups_prefix=/usr
		else
			cups_prefix=$withval
		fi
		cups_enable=yes
	])

	CUPS_BACKEND_DIR=""

	if test "$cups_enable" = "yes"; then
		AC_MSG_CHECKING(for CUPS backend directory)

		if (test -d "$cups_prefix/lib/cups/backend"); then
			CUPS_BACKEND_DIR="$cups_prefix/lib/cups/backend"
		elif (test -d "$libdir/cups/backend"); then
			CUPS_BACKEND_DIR="$libdir/cups/backend"
		else
			cups_enable=no
		fi

		if test "$cups_enable" = "yes"; then
			AC_MSG_RESULT($CUPS_BACKEND_DIR)
		else
			AC_MSG_RESULT($cups_enable)
		fi
	fi

	AC_SUBST(CUPS_BACKEND_DIR)

	AM_CONDITIONAL(CUPS, test "$cups_enable" = "yes")
])
