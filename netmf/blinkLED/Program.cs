using System;
using Microsoft.SPOT;
using Microsoft.SPOT.Hardware;

namespace BlinkLED
{
   public class Program
   {
      public static void Main()
      {
         //Debug.Print(Resources.GetString(Resources.StringResources.String1));
         OutputPort led1 = new OutputPort((Cpu.Pin)60, false);
         OutputPort led2 = new OutputPort((Cpu.Pin)61, false);
         OutputPort led3 = new OutputPort((Cpu.Pin)62, false);
         OutputPort led4 = new OutputPort((Cpu.Pin)63, false);

         while (true)
         {
            led4.Write(true);
            System.Threading.Thread.Sleep(750);
            led1.Write(true);
            System.Threading.Thread.Sleep(750);
            led2.Write(true);
            System.Threading.Thread.Sleep(750);
            led3.Write(true);
            System.Threading.Thread.Sleep(750);
            led1.Write(false);
            System.Threading.Thread.Sleep(250);
            led3.Write(false);
            System.Threading.Thread.Sleep(250);
            led2.Write(false);
            System.Threading.Thread.Sleep(250);
            led4.Write(false);
            System.Threading.Thread.Sleep(1000);
         }
      }

   }
}
