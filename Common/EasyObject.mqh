//+------------------------------------------------------------------+
//|                                                   CEasyObject.mqh |
//|                           https://www.mql5.com/en/users/icreator |
//|                                            ic.icreator@gmail.com |
//+------------------------------------------------------------------+
#property copyright "ic.icreator@gmail.com"
#property link      "https://www.mql5.com/en/users/icreator"
#property strict
#property version "1.24"
//+------------------------------------------------------------------+
//| CEasyObject class                                                 |
//+------------------------------------------------------------------+
class CEasyObject
  {
private:

   string            m_obj_name;
   long              m_chart_id;
   ENUM_OBJECT       m_obj_type;
   int               m_sub_window;

public:
                     CEasyObject(void)
     {
      m_chart_id=0;
      m_sub_window=0;
      m_obj_type=-1;
     };
                    ~CEasyObject(void) {};

   //--- setters

   CEasyObject *chartID(long id)
     {
      this.m_chart_id=id;
      return GetPointer(this);
     }

   CEasyObject *type(ENUM_OBJECT type)
     {
      this.m_obj_type=type;
      ObjectCreate(chartID(),name(),type,0,0,0);
      return GetPointer(this);
     }

   CEasyObject *colour(color inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_COLOR,inp);
      return GetPointer(this);
     }

   CEasyObject *style(ENUM_LINE_STYLE inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_STYLE,inp);
      return GetPointer(this);
     }

   CEasyObject *width(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_WIDTH,inp);
      return GetPointer(this);
     }

   CEasyObject *back(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_BACK,inp);
      return GetPointer(this);
     }

   CEasyObject *zOrder(long inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ZORDER,inp);
      return GetPointer(this);
     }

   CEasyObject *fill(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_FILL,inp);
      return GetPointer(this);
     }

   CEasyObject *hidden(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_HIDDEN,inp);
      return GetPointer(this);
     }

   CEasyObject *selected(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_SELECTED,inp);
      return GetPointer(this);
     }

   CEasyObject *readOnly(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_READONLY,inp);
      return GetPointer(this);
     }

   CEasyObject *time(datetime inp,int anchor_point=0)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_TIME,anchor_point,inp);
      return GetPointer(this);
     }

   CEasyObject *selectable(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_SELECTABLE,inp);
      return GetPointer(this);
     }

   CEasyObject *levels(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_LEVELS,inp);
      return GetPointer(this);
     }

   CEasyObject *levelColor(color inp,int level_number=0)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_LEVELCOLOR,level_number,inp);
      return GetPointer(this);
     }

   CEasyObject *levelStyle(ENUM_LINE_STYLE inp,int level_number=0)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_LEVELSTYLE,level_number,inp);
      return GetPointer(this);
     }

   CEasyObject *levelWidth(int inp,int level_number=0)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_LEVELWIDTH,level_number,inp);
      return GetPointer(this);
     }

   CEasyObject *align(ENUM_ALIGN_MODE inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ALIGN,inp);
      return GetPointer(this);
     }

   CEasyObject *fontSize(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_FONTSIZE,inp);
      return GetPointer(this);
     }

   CEasyObject *ray(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_RAY,inp);
      return GetPointer(this);
     }

   CEasyObject *rayRight(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_RAY_RIGHT,inp);
      return GetPointer(this);
     }

   CEasyObject *ellipse(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ELLIPSE,inp);
      return GetPointer(this);
     }

   CEasyObject *arrowCode(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ARROWCODE,inp);
      return GetPointer(this);
     }

   CEasyObject *timeframes(long inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_TIMEFRAMES,inp);
      return GetPointer(this);
     }

   CEasyObject *anchor(ENUM_ARROW_ANCHOR inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ANCHOR,inp);
      return GetPointer(this);
     }

   CEasyObject *anchor(ENUM_ANCHOR_POINT inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_ANCHOR,inp);
      return GetPointer(this);
     }

   CEasyObject *x(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_XDISTANCE,inp);
      return GetPointer(this);
     }

   CEasyObject *y(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_YDISTANCE,inp);
      return GetPointer(this);
     }

   CEasyObject *direction(ENUM_GANN_DIRECTION inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_DIRECTION,inp);
      return GetPointer(this);
     }

   CEasyObject *state(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_STATE,inp);
      return GetPointer(this);
     }

   CEasyObject *xSize(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_XSIZE,inp);
      return GetPointer(this);
     }

   CEasyObject *ySize(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_YSIZE,inp);
      return GetPointer(this);
     }

   CEasyObject *xOffset(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_XOFFSET,inp);
      return GetPointer(this);
     }

   CEasyObject *yOffset(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_YOFFSET,inp);
      return GetPointer(this);
     }

   CEasyObject *period(ENUM_TIMEFRAMES inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_PERIOD,inp);
      return GetPointer(this);
     }

   CEasyObject *dateScale(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_DATE_SCALE,inp);
      return GetPointer(this);
     }

   CEasyObject *priceScale(bool inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_PRICE_SCALE,inp);
      return GetPointer(this);
     }

   CEasyObject *chartScale(int inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_CHART_SCALE,inp);
      return GetPointer(this);
     }

   CEasyObject *bgColor(color inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_BGCOLOR,inp);
      return GetPointer(this);
     }

   CEasyObject *corner(ENUM_BASE_CORNER inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_CORNER,inp);
      return GetPointer(this);
     }

   CEasyObject *borderType(ENUM_BORDER_TYPE inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_BORDER_TYPE,inp);
      return GetPointer(this);
     }

   CEasyObject *borderColor(color inp)
     {
      ObjectSetInteger(chartID(),name(),OBJPROP_BORDER_COLOR,inp);
      return GetPointer(this);
     }

   CEasyObject *price(double price,int anchor_point=0)
     {
      ObjectSetDouble(0,name(),OBJPROP_PRICE,anchor_point,price);
      return GetPointer(this);
     }

   CEasyObject *levelValue(double inp,int level_number=0)
     {
      ObjectSetDouble(chartID(),name(),OBJPROP_LEVELVALUE,level_number,inp);
      return GetPointer(this);
     }

   CEasyObject *scale(double inp)
     {
      ObjectSetDouble(chartID(),name(),OBJPROP_SCALE,inp);
      return GetPointer(this);
     }

   CEasyObject *angle(double inp)
     {
      ObjectSetDouble(chartID(),name(),OBJPROP_ANGLE,inp);
      return GetPointer(this);
     }

   CEasyObject *deviation(double inp)
     {
      ObjectSetDouble(chartID(),name(),OBJPROP_DEVIATION,inp);
      return GetPointer(this);
     }

   CEasyObject *name(const string name)
     {
      this.m_obj_name=name;
      return GetPointer(this);
     }

   CEasyObject *text(string inp)
     {
      ObjectSetString(chartID(),name(),OBJPROP_TEXT,inp);
      return GetPointer(this);
     }

   CEasyObject *tooltip(string inp)
     {
      ObjectSetString(chartID(),name(),OBJPROP_TOOLTIP,inp);
      return GetPointer(this);
     }

   CEasyObject *levelText(string inp,int level_number=0)
     {
      ObjectSetString(chartID(),name(),OBJPROP_LEVELTEXT,level_number,inp);
      return GetPointer(this);
     }

   CEasyObject *font(string inp)
     {
      ObjectSetString(chartID(),name(),OBJPROP_FONT,inp);
      return GetPointer(this);
     }

   CEasyObject *bmpFile(string inp,int state=0)
     {
      ObjectSetString(chartID(),name(),OBJPROP_BMPFILE,state,inp);
      return GetPointer(this);
     }

   CEasyObject *symbol(string inp)
     {
      ObjectSetString(chartID(),name(),OBJPROP_SYMBOL,inp);
      return GetPointer(this);
     }

   CEasyObject *move(datetime time,double price,int point_index=0)
     {
      ObjectMove(chartID(),name(),point_index,time,price);
      return GetPointer(this);
     }

   //--- getters

   const string name()
     {
      return m_obj_name;
     }

   const ENUM_OBJECT type()
     {
      return m_obj_type;
     }

   const long chartID()
     {
      return m_chart_id;
     }

   color colour()
     {
      return (color)ObjectGetInteger(chartID(),name(),OBJPROP_COLOR);
     }

   ENUM_LINE_STYLE style()
     {
      return (ENUM_LINE_STYLE)ObjectGetInteger(chartID(),name(),OBJPROP_STYLE);
     }

   int width()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_WIDTH);
     }

   bool back()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_BACK);
     }

   long zOrder()
     {
      return ObjectGetInteger(chartID(),name(),OBJPROP_ZORDER);
     }

   bool fill()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_FILL);
     }

   bool hidden()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_HIDDEN);
     }

   bool selected()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_SELECTED);
     }

   bool readOnly()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_READONLY);
     }

   datetime time()
     {
      return (datetime)ObjectGetInteger(chartID(),name(),OBJPROP_TIME);
     }

   bool selectable()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_SELECTABLE);
     }

   int levels()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_LEVELS);
     }

   color levelColor()
     {
      return (color)ObjectGetInteger(chartID(),name(),OBJPROP_LEVELCOLOR);
     }

   ENUM_LINE_STYLE levelStyle()
     {
      return (ENUM_LINE_STYLE)ObjectGetInteger(chartID(),name(),OBJPROP_LEVELSTYLE);
     }

   int levelWidth()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_LEVELWIDTH);
     }

   ENUM_ALIGN_MODE align()
     {
      return (ENUM_ALIGN_MODE)ObjectGetInteger(chartID(),name(),OBJPROP_ALIGN);
     }

   int fontSize()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_FONTSIZE);
     }

   bool ray()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_RAY);
     }

   bool rayRight()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_RAY_RIGHT);
     }

   bool ellipse()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_ELLIPSE);
     }

   char arrowCode()
     {
      return (char)ObjectGetInteger(chartID(),name(),OBJPROP_ARROWCODE);
     }

   long timeframes()
     {
      return ObjectGetInteger(chartID(),name(),OBJPROP_TIMEFRAMES);
     }

   ENUM_ANCHOR_POINT anchor()
     {
      return (ENUM_ANCHOR_POINT)ObjectGetInteger(chartID(),name(),OBJPROP_ANCHOR);
     }

   int x()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_XDISTANCE);
     }

   int y()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_YDISTANCE);
     }

   ENUM_GANN_DIRECTION direction()
     {
      return (ENUM_GANN_DIRECTION)ObjectGetInteger(chartID(),name(),OBJPROP_DIRECTION);
     }

   bool state()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_STATE);
     }

   int xSize()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_XSIZE);
     }

   int ySize()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_YSIZE);
     }

   int xOffset()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_XOFFSET);
     }

   int yOffset()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_YOFFSET);
     }

   ENUM_TIMEFRAMES period()
     {
      return (ENUM_TIMEFRAMES)ObjectGetInteger(chartID(),name(),OBJPROP_PERIOD);
     }

   bool dateScale()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_DATE_SCALE);
     }

   bool priceScale()
     {
      return (bool)ObjectGetInteger(chartID(),name(),OBJPROP_PRICE_SCALE);
     }

   int chartScale()
     {
      return (int)ObjectGetInteger(chartID(),name(),OBJPROP_CHART_SCALE);
     }

   color bgColor()
     {
      return (color)ObjectGetInteger(chartID(),name(),OBJPROP_BGCOLOR);
     }

   ENUM_BASE_CORNER corner()
     {
      return (ENUM_BASE_CORNER)ObjectGetInteger(chartID(),name(),OBJPROP_CORNER);
     }

   ENUM_BORDER_TYPE borderType()
     {
      return (ENUM_BORDER_TYPE)ObjectGetInteger(chartID(),name(),OBJPROP_BORDER_TYPE);
     }

   double price()
     {
      return ObjectGetDouble(chartID(),name(),OBJPROP_PRICE);
     }

   double levelValue()
     {
      return ObjectGetDouble(chartID(),name(),OBJPROP_LEVELVALUE);
     }

   double scale()
     {
      return ObjectGetDouble(chartID(),name(),OBJPROP_SCALE);
     }

   double angle()
     {
      return ObjectGetDouble(chartID(),name(),OBJPROP_ANGLE);
     }

   double deviation()
     {
      return ObjectGetDouble(chartID(),name(),OBJPROP_DEVIATION);
     }

   string text()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_TEXT);
     }

   string tooltip()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_TOOLTIP);
     }

   string levelText()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_LEVELTEXT);
     }

   string font()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_FONT);
     }

   string bmpFile()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_BMPFILE);
     }

   string symbol()
     {
      return ObjectGetString(chartID(),name(),OBJPROP_SYMBOL);
     }

   CEasyObject *priceToY(double price)
     {
      int x,y;
      ChartTimePriceToXY(chartID(),0,TimeCurrent(),price,x,y);
      ENUM_ANCHOR_POINT point=anchor();
      return y(y+(point==ANCHOR_RIGHT_LOWER?-4:0));
     }

   CEasyObject *XYToPrice(int x,int y)
     {
      datetime time;
      double price;
      ChartXYToTimePrice(chartID(),x,y,m_sub_window,time,price);
      price(price);
      time(time);

      return GetPointer(this);
     }

   bool exists()
     {
      if(ObjectFind(chartID(),name())>=0)
         return true;
      return false;
     }

   int priceToY()
     {
      int x,y;
      ChartTimePriceToXY(chartID(),0,TimeCurrent(),price(),x,y);
      return y;
     }

   void XY(int &x,int &y)
     {
      datetime time=time();
      if(time==0) time=Time[0];
      ChartTimePriceToXY(chartID(),0,time,price(),x,y);
     }

   bool remove()
     {
      return ObjectDelete(chartID(),name());
     }
  };
//--- defines an instance of the class
CEasyObject object();
//+------------------------------------------------------------------+
//| Returns pointer to the object initialized by name                |
//+------------------------------------------------------------------+
CEasyObject *_(string name)
  {
   object.name(name);
   return GetPointer(object);
  }
//+------------------------------------------------------------------+
