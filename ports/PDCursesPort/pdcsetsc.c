
#include "pdcrtos.h"

/*
 * Called from curs_set(). Changes the appearance of the cursor --
 * 0 turns it off, 1 is normal (the terminal's default, if applicable, as
 * determined by SP->orig_cursor), and 2 is high visibility. The exact
 * appearance of these modes is not specified.
 */
int PDC_curs_set(int visibility)
{

}

