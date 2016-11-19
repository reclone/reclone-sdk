#include "TestCursesApp.h"
#include "curses.h"

TestCursesApp::TestCursesApp()
{

}

bool TestCursesApp::HardwareInit()
{

}

void TestCursesApp::Run()
{
   initscr();        /* Start curses mode         */
   printw("Hello World !!!"); /* Print Hello World      */
   refresh();        /* Print it on to the real screen */
   //getch();       /* Wait for user input */
   //endwin();         /* End curses mode        */

   while (true)
   {
      Delay(1000);
   }
}

