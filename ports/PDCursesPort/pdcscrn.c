#include "pdcrtos.h"

/*
 * Returns TRUE if init_color() and color_content() give meaningful results, FALSE otherwise. Called from can_change_color().
 */
bool PDC_can_change_color(void)
{

}

/*
 * The core of color_content(). This does all the work of that function,
 * except checking for values out of range and null pointers.
 */
int PDC_color_content(short color, short *red, short *green, short *blue)
{

}

/*
 * The core of init_color(). This does all the work of that function,
 * except checking for values out of range.
 */
int PDC_init_color(short color, short red, short green, short blue)
{

}

/*
 * The core of init_pair(). This does all the work of that function, except
 * checking for values out of range. The values passed to this function
 * should be returned by a call to PDC_pair_content() with the same pair
 * number. PDC_transform_line() should use the specified colors when
 * rendering a chtype with the given pair number.
 */
void PDC_init_pair(short pair, short fg, short bg)
{

}

/*
 * The core of pair_content(). This does all the work of that function,
 * except checking for values out of range and null pointers.
 */
int PDC_pair_content(short pair, short *fg, short *bg)
{

}

/*
 * The non-portable functionality of reset_prog_mode() is handled here --
 * whatever's not done in _restore_mode(). In current ports: In OS/2,
 * this sets the keyboard to binary mode; in Win32, it enables or disables
 * the mouse pointer to match the saved mode; in others it does nothing.
 */
void PDC_reset_prog_mode(void)
{

}

/*
 * The same thing, for reset_shell_mode(). In OS/2 and Win32, it restores
 * the default console mode; in others it does nothing.
 */
void PDC_reset_shell_mode(void)
{

}

/*
 * This does the main work of resize_term(). It may respond to non-zero
 * parameters, by setting the screen to the specified size; to zero
 * parameters, by setting the screen to a size chosen by the user at
 * runtime, in an unspecified way (e.g., by dragging the edges of the
 * window); or both. It may also do nothing, if there's no appropriate
 * action for the platform.
 */
int PDC_resize_screen(int nlines, int ncols)
{

}

/*
 * Called from _restore_mode() in kernel.c, this function does the actual
 * mode changing, if applicable. Currently used only in DOS and OS/2.
 */
void PDC_restore_screen_mode(int i)
{

}

/*
 * Called from _save_mode() in kernel.c, this function saves the actual
 * screen mode, if applicable. Currently used only in DOS and OS/2.
 */
void PDC_save_screen_mode(int i)
{

}

/*
 * The platform-specific part of endwin(). It may restore the image of the
 * original screen saved by PDC_scr_open(), if the PDC_RESTORE_SCREEN
 * environment variable is set; either way, if using an existing terminal,
 * this function should restore it to the mode it had at startup, and move
 * the cursor to the lower left corner. (The X11 port does nothing.)
 */
void PDC_scr_close(void)
{

}

/*
 * Frees the memory for SP allocated by PDC_scr_open(). Called by delscreen().
 */
void PDC_scr_free(void)
{

}

/*
 * The platform-specific part of initscr(). It's actually called from
 * Xinitscr(); the arguments, if present, correspond to those used with
 * main(), and may be used to set the title of the terminal window, or for
 * other, platform-specific purposes. (The arguments are currently used
 * only in X11.) PDC_scr_open() must allocate memory for SP, and must
 * initialize acs_map and several members of SP, including lines, cols,
 * mouse_wait, orig_attr (and if orig_attr is TRUE, orig_fore and
 * orig_back), mono, _restore and _preserve. (Although SP is used the
 * same way in all ports, it's allocated here in order to allow the X11
 * port to map it to a block of shared memory.) If using an existing
 * terminal, and the environment variable PDC_RESTORE_SCREEN is set, this
 * function may also store the existing screen image for later restoration
 * by PDC_scr_close().
 */
int PDC_scr_open(int argc, char **argv)
{

}


