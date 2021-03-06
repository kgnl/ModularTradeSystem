//+------------------------------------------------------------------+
//|                                                     ShowUtil.mqh |
//|                                     Copyright 2020, Michael Wade |
//|                                             michaelwade@yeah.net |
//+------------------------------------------------------------------+
//| Provide some utils about showing
//+------------------------------------------------------------------+
#property strict
#include "Const.mqh"

//+------------------------------------------------------------------+
//| Show a lable on screen                                                                 |
//+------------------------------------------------------------------+
void ShowLable(string name,
               string text,
               int winCorner,
               int lableX,
               int lableY,
               int textSize,
               string textStyle,
               color textColor)
  {
   if(winCorner == -1)
      return;
//int myWindowsHandle = WindowFind(WindowExpertName());
//LableName=LableName+DoubleToStr(myWindowsHandle,0);
   ObjectCreate(name, OBJ_LABEL, 0, 0, 0); //建立标签对象
   ObjectSetText(name, text, textSize, textStyle,textColor); //定义对象属性
   ObjectSet(name, OBJPROP_CORNER, winCorner); // Determine the origin of coordinates，0:leftTop,1:rightTop,2:leftBottom,3:rightBottom,-1:gone
   ObjectSet(name, OBJPROP_XDISTANCE, lableX); // Define coordinate X, unit pixel
   ObjectSet(name, OBJPROP_YDISTANCE, lableY); // Define coordinate Y, unit pixel
  }

//+------------------------------------------------------------------+
//| Show dynamic text on screen，the text can move as prices change.                                                                 |
//+------------------------------------------------------------------+
void ShowDynamicText(string name,string content,int barIndex,double offsetPointY)
  {
   ObjectDelete(name);
   ObjectCreate(name,OBJ_TEXT,0,Time[barIndex],Close[0]+offsetPointY*Point);
   ObjectSetText(name,content,15,"Arial",Red);
  }

//+------------------------------------------------------------------+
//| Draw a divider when the trend changes                                                               |
//+------------------------------------------------------------------+
void DrawTrendDivider(int trend)
  {
   string objName ="Divider"+TimeToString(Time[0]);
   ObjectCreate(objName,OBJ_VLINE,0,Time[0],0);
   ObjectSetInteger(0,objName,OBJPROP_COLOR,trend == TREND_NO ? clrWhite: (trend==TREND_UP ? clrGreen:clrRed));
  }


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
