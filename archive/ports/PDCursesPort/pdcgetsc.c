#include "pdcrtos.h"

/*
 * Returns the size of the screen in columns. It's used in resize_term()
 * to set the new value of COLS. (Some existing implementations also
 * call it internally from PDC_scr_open(), but this is not required.)
 */
int PDC_get_columns(void)
{
   return 80;
}

/*
 * Returns the size of the screen in rows. It's used in resize_term()
 * to set the new value of LINES. (Some existing implementations also
 * call it internally from PDC_scr_open(), but this is not required.)
 */
int PDC_get_rows(void)
{
   return 25;
}

/*
 * Returns the size/shape of the cursor. The format of the result is
 * unspecified, except that it must be returned as an int. This
 * function is called from initscr(), and the result is stored in
 * SP->orig_cursor, which is used by PDC_curs_set() to determine
 * the size/shape of the cursor in normal visibility mode
 * (curs_set(1)).
 */
int PDC_get_cursor_mode(void)
{
   //FIXME
   return 0;
}

