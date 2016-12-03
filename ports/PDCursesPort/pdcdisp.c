
#include "pdcrtos.h"

volatile uint16_t * const TEXTBUFFER_BASE = (volatile uint16_t *)0x60000000;
static const uint16_t TEXTBUFFER_MAX_COLS = 128;

/* ACS definitions originally by jshumate@wrdis01.robins.af.mil -- these
   match code page 437 and compatible pages (CP850, CP852, etc.) */

#define A(x) ((chtype)x | A_ALTCHARSET)

chtype acs_map[128] =
{
    A(0), A(1), A(2), A(3), A(4), A(5), A(6), A(7), A(8), A(9), A(10),
    A(11), A(12), A(13), A(14), A(15), A(16), A(17), A(18), A(19),
    A(20), A(21), A(22), A(23), A(24), A(25), A(26), A(27), A(28),
    A(29), A(30), A(31), ' ', '!', '"', '#', '$', '%', '&', '\'', '(',
    ')', '*',

    A(0x1a), A(0x1b), A(0x18), A(0x19),

    '/',

    0xdb,

    '1', '2', '3', '4', '5', '6', '7', '8', '9', ':', ';', '<', '=',
    '>', '?', '@', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W',
    'X', 'Y', 'Z', '[', '\\', ']', '^', '_',

    A(0x04), 0xb1,

    'b', 'c', 'd', 'e',

    0xf8, 0xf1, 0xb0, A(0x0f), 0xd9, 0xbf, 0xda, 0xc0, 0xc5, 0x2d, 0x2d,
    0xc4, 0x2d, 0x5f, 0xc3, 0xb4, 0xc1, 0xc2, 0xb3, 0xf3, 0xf2, 0xe3,
    0xd8, 0x9c, 0xf9,

    A(127)
};

/*
 * Move the physical cursor (as opposed to the logical cursor affected
 * by wmove()) to the given location. This is called mainly from
 * doupdate(). In general, this function need not compare the old
 * location with the new one, and should just move the cursor unconditionally.
 */
void PDC_gotoyx(int y, int x)
{
   PDC_LOG(("PDC_gotoyx() - called: row %d col %d\n", row, col));

   //TODO
}

/*
 * The core output routine. It takes len chtype entities from srcp
 * (a pointer into curscr) and renders them to the physical screen
 * at line lineno, column x. It must also translate characters 0-127
 * via acs_map[], if they're flagged with A_ALTCHARSET in the attribute
 * portion of the chtype.
 */
void PDC_transform_line(int lineno, int x, int len, const chtype *srcp)
{

   PDC_LOG(("PDC_transform_line() - called: line %d\n", lineno));

   for (int idx = 0; idx < len; ++idx)
   {
      int col = x + idx;
      chtype ch = srcp[idx];

      // Decode character from alternate character set
      if (ch & A_ALTCHARSET && !(ch & 0xff80))
      {
         ch = acs_map[ch & 0x7f];
      }

      // Low byte (bits 7-0) is the character code
      uint16_t dest_char = (uint16_t)(ch & 0xFF);
      // Get background color and foreground color
      uint8_t bg = (pdc_atrtab[ch >> PDC_COLOR_SHIFT] & 0xF0) >> 4;
      uint8_t fg = pdc_atrtab[ch >> PDC_COLOR_SHIFT] & 0x0F;
      // Init attribute byte
      uint8_t att = fg | (bg << 4);

      // If reverse, swap foreground and background
      if (ch & A_REVERSE)
      {
         att = bg | (fg << 4);
      }

      // If underline, just do blue foreground and black background
      // (matches PDCurses DOS port)
      if (ch & A_UNDERLINE)
      {
         att = 1;
      }

      // If invisible, use background color as foreground color
      if (ch & A_INVIS)
      {
         uint8_t temp_bg = att >> 4;
         att = (temp_bg << 4) | temp_bg;
      }

      // If bold, brighten the foreground color
      if (ch & A_BOLD)
      {
         att |= 8;
      }

      // If blink, set the high bit so the video card knows to blink it
      if (ch & A_BLINK)
      {
         att |= 128;
      }

      // Set the attribute byte
      dest_char |= ((uint16_t)att) << 8;

      // Write the
      TEXTBUFFER_BASE[(lineno + 1) * TEXTBUFFER_MAX_COLS + col] = dest_char;
   }

}
