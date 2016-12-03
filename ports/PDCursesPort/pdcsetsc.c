
#include "pdcrtos.h"

/*
 * Called from curs_set(). Changes the appearance of the cursor --
 * 0 turns it off, 1 is normal (the terminal's default, if applicable, as
 * determined by SP->orig_cursor), and 2 is high visibility. The exact
 * appearance of these modes is not specified.
 */
int PDC_curs_set(int visibility)
{
   PDCREGS regs;
   int ret_vis, start, end;

   PDC_LOG(("PDC_curs_set() - called: visibility=%d\n", visibility));

   ret_vis = SP->visibility;
   SP->visibility = visibility;

   switch (visibility)
   {
      case 0:  /* invisible */
         start = 32;
         end = 0;  /* was 32 */
         break;
      case 2:  /* highly visible */
         start = 0;   /* full-height block */
         end = 7;
         break;
      default:  /* normal visibility */
         start = (SP->orig_cursor >> 8) & 0xff;
         end = SP->orig_cursor & 0xff;
         break;
   }

   // Write the new start and end lines to the text renderer
   // (start << 8) | end;

   // Return the old visibility setting
   return ret_vis;
}


/*
 * PDC_set_blink() toggles whether the A_BLINK attribute sets an
 * actual blink mode (TRUE), or sets the background color to high
 * intensity (FALSE). The default is platform-dependent (FALSE in
 * most cases). It returns OK if it could set the state to match
 * the given parameter, ERR otherwise. Current platforms also
 * adjust the value of COLORS according to this function -- 16 for
 * FALSE, and 8 for TRUE.
 */
int PDC_set_blink(bool blinkon)
{
   if (pdc_color_started)
   {
      COLORS = blinkon ? 8 : 16;
   }

   return (COLORS - (blinkon * 8) != 8) ? OK : ERR;
}

/*
 * PDC_set_title() sets the title of the window in which the curses
 * program is running. This function may not do anything on some
 * platforms. (Currently it only works in Win32 and X11.)
 */
void PDC_set_title(const char *title)
{
   PDC_LOG(("PDC_set_title() - called: <%s>\n", title));
}

