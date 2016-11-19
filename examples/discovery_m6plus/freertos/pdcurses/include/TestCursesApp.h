

#ifndef __TESTCURSESAPP_H
#define __TESTCURSESAPP_H

#include "AManagedTask.h"
#include "stm32f4xx.h"

class TestCursesApp : public AManagedTask
{
public:
   TestCursesApp();
   void Run();
   bool HardwareInit();
   virtual ~TestCursesApp() = default;

private:


};

#endif
