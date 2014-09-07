unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TeEngine, Series, StdCtrls, ExtCtrls, TeeProcs, Chart, jpeg,
  VclTee.TeeGDIPlus;

type
  TForm1 = class(TForm)
    Edit2: TEdit;
    Chart1: TChart;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Series1: TBarSeries;
    RadioGroup1: TRadioGroup;
    Image1: TImage;
    Button3: TButton;
    Label3: TLabel;
    Series2: TBarSeries;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);




  private
    { Private declarations }
  public
    { Public declarations }
  end;
  const
  n=41;
var
  Form1: TForm1;


implementation

{$R *.dfm}
function Generator(var Zatr:int64):real;
begin

Zatr:= (67*Zatr+75) mod 90007; {изменение глобальной переменной}
Generator:=Zatr/90007;

end;
function GeneratorY(var Zatr:int64):real;
begin
Zatr:= (78*Zatr+34) mod 90001; {изменение глобальной переменной}
GeneratorY:=Zatr/90001;

end;

procedure TForm1.Button1Click(Sender: TObject);
var x,Zata,Zatb: int64;
    Kol,k,p, i,j: integer;
    xi,x1,y1,r: real;
    MassGIST: array[0..n] of double;
    fl:boolean;
    g:textfile;
    filename: string;
begin
  x:=0;xi:=0;
  for k := 0 to n do
  begin
    MassGIST[k] := 0;
  end;

  k:=0;

  if RadioGroup1.ItemIndex=0 then
  begin

////Генератор равномерного распределения
///Подобрана затравка 897694123  При ней период будет около 70К

    Chart1.Series[0].Clear;
    x:=StrToInt(Edit1.text);
    x1:=Generator(x);
    Kol:=StrToInt(Edit2.text);
    if x=0 then
    begin
      ShowMessage('Затравка не подходит, выберете новую затравку');
    end;
    while(k<kol)and(x>0) do
    begin
      x:=(67*x+75) mod 90007;
      xi:=x/90007;
      fl:=true;
      inc(k);
      i:=0;
      while (i<=n)and fl do
      begin
        if xi<=i*(1/(n+1)) then
        begin
          massGIST[i] := massGIST[i]+1;
          fl:=false;
        end;
        inc(i);
      end;

    end;

    Chart1.Series[0].AddArray(massGIST);


    AssignFile(g,'Равномерное распределение.txt');
    Rewrite(g);
    for i:=0 to n do
    begin
      writeln(g,massGIST[i]:5:0);
    end;
    CloseFile(g);
  end

 else
  begin
    Chart1.Series[0].Clear;
    x1:=0;
    Zata :=7454914 ;
    Zatb :=5425637 ;
     r:=0;
    for i := 0 to n do
      massGIST[i] := 0;

    for i := 1 to 60800 do
    begin
      x1 := Generator(Zata) * 6;
      y1 := GeneratorY(Zatb) * 0.2;
      if (   (x1 >= 3)  and (x1 <= 5) and (y1 <= (0.5*(0.7-0.1*x1))) )
        or ( (x1 >= 0) and (x1 < 2)  and (y1 <= (0.1)) )
        or ( (x1 >= 2) and (x1 < 3) and (y1 <= (0.2)) )
      then
      begin
        fl:=true;
        j:=0;
        while (j<=n+1)and fl do
        begin
          if x1<=j*(6/(n+1)) then
          begin
            massGIST[j] := massGIST[j]+1;

            fl:=false;
          end;
          inc(j);
        end;
      end;

    end;
    for i:=0 to n do
    r:= r+massGIST[i];
    p:=round(r);
    label3.Caption:=Inttostr(p);
    Chart1.Series[0].AddArray(massGist);


    AssignFile(g,'Заданное распределение.txt');
    Rewrite(g);

    for i:=0 to n do
      writeln(g, massGIST[i]:5:0);
    CloseFile(g);
  end;

end;



procedure TForm1.Button2Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Button3Click(Sender: TObject);

var x,r,i:integer;
    hlow,hhi,l,h,low,hi,l1,l2,l3:real;
    massT:array [0..n]of real;
    massGTER:array[0..n]of double;
    g:textfile;

begin
h:=1/5;
l:=5/(n+1); l1:=2; l2:=3; l3:=6;
for i:=0 to n do
begin
  massT[i]:=0; MassGTER[i]:=0;
end;
  if  (label3.Caption='<Количество точек попавших в Заданное распределение>')then
  showmessage('Количество экспериментально полученных попаданий равно нулю повторите эксперимент')
  else r:=Strtoint(label3.Caption);

 hi:=0;

 for i:=0 to n do
 begin
 low:=hi;
 hi:=hi+l;
 hlow:=h-low*(1/20);
 hhi:=h-hi*(1/20);
if hi<l1 then
begin
MassT[i]:=((l/2)*(hhi+hlow))*r;
end
else
if (hi>l1) and (low<l1) then
begin
MassT[i]:=(((l1-low)/2)*(hhi+hlow)+(hi-l1)*(h/2))*r;
end
else
if hi<l2 then
begin
MassT[i]:=(h*l/2)*r;
end
else
if (hi>l2) and (low<l2) then
begin
MassT[i]:=((h/2)*(l2-low)+h*(hi-l2))*r;
end
else if (hi<l3) then
begin
MassT[i]:=(h*l)*r;
end
else if (hi>l3) and (low<l3) then
begin MassT[i]:=((l3-low)*h)*r; end;
  end;

for i:=0 to n do
MassGTER[i]:=round(MassT[i]);

  Chart1.Series[1].AddArray(massGTER);
   AssignFile(g,'Заданное теор распределение.txt');
    Rewrite(g);

    for i:=0 to n do
      writeln(g, round(massT[i]));
    CloseFile(g);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
 Chart1.Series[0].Clear;
 Chart1.Series[1].Clear;
end;



end.

