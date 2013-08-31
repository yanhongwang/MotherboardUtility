#define BYTE  unsigned char
#define WORD  unsigned int
#define DWORD unsigned long
void delay_g(unsigned int t)
{
   unsigned int i;
   for(i=1;i<=t;i++)
   {
      asm out 0edh, al
      asm out 0edh, al
      asm out 0edh, al
      asm out 0edh, al
      asm out 0edh, al
      asm out 0edh, al
   }
}
unsigned long pow_g(unsigned int v,char  x)
{
   int i,j=1;
   if(x<0)
   {
     for(i=x;i<=-1;i++)
     {
        j=j/v;
     }
   }
   else if(x>0)
   {
     for(i=1;i<=x;i++)
     {
        j=j*v;
     }
   }
   return j;
}
void printf_g(int attr,char x)
{
    asm mov   bh,0
    asm mov   al,x
    asm mov   bl,byte ptr attr
    asm mov   cx,1
    asm mov   ah,09h
    asm int 10h
}
int inkey_g(void) // Gigabyte inkey function
{
   unsigned int key_value;
   asm mov di,0x041C
   asm mov ax,0
   asm mov es,ax
   asm mov ax,es:[di]
   asm mov es:[di-2],ax
   asm mov di,0x03FE
   asm add di,ax
   asm mov ax,0
   asm mov es,ax
   asm mov ax,es:[di]
   asm mov key_value,ax
   asm mov ax,0
   asm mov es,ax
   asm mov ax,0x6600
   asm mov es:[di],ax
   return  key_value;
}
int getch_g(void) // Gigabyte getch function
{
   int gch;
   asm mov   ah,00h
   asm int   16h
   asm mov   gch,ax
   return    gch;
}
void gotoxy_g(int x,int y) // Gigabyte gotoxy function
{
   asm mov   bh,0
   asm mov   ah,02h
   asm mov   dh,byte ptr y
   asm mov   dl,byte ptr x
   asm dec   dh
   asm dec   dl
   asm int   10h
   asm
}
int strlen_g(char *s)
{
        int i=0;
        while (s[i] != 0)       i++;
        return i;
}
void cputs_g(int x,int y,int attr,char *str)  //Gigabyte puts char function
{
   int i,posx,posy;
   char *pstr;

   for(i=0;i<strlen_g(str);i++)
   {
       gotoxy_g(x+i,y);
       pstr=str+i;
       asm {
       mov     si,word ptr pstr
       xor     bx,bx
       xor     cx,cx
       inc     cx
       mov     ah,09h
       mov     bl,byte ptr attr
       mov     al,[si]
       int     10h
       }
   }
}
void dputs_g(int x,int y,int attr,unsigned long dec ,unsigned char t) //Gigabyte puts Digtal function
{
   int i,j=0;
   unsigned char dec_temp;
   if(t==0)
   {
      while(dec!=0)
      {
         dec_temp=dec%10;
         dec_temp+=0x30;
         dec=dec/10;
         gotoxy_g(x+2,y);
         printf_g(attr,dec_temp);
         x--;
         j++;
      }
      if(j==0)
      {
          gotoxy_g(x+2,y);
          printf_g(attr,0x30);
      }
   }
   else
   {
      for(i=t;i>=1;i--)
      {
         dec_temp=dec%10;
         dec_temp+=0x30;
         dec=dec/10;
         gotoxy_g(x+i-1,y);
         printf_g(attr,dec_temp);
      }
   }
}
void fputs_g(int x,int y,int attr,long dec ,char t)
{
   int i,j=0,temp;
   unsigned char dec_temp;
   long dec2=dec;
   if(t>7)
   {
      while (t<16)
      //for(i=t;i<16;i++)
      {
         dec_temp=dec%10;
         dec=dec/10;
         if(dec2<0)
         {
            asm mov al,dec_temp
            asm not al
            asm inc al
            asm mov dec_temp,al
         }
         if(t>13)
         {
            gotoxy_g(x+2,y);
            printf_g(attr,dec_temp+0x30);
            x--;
         }
         t++;
      }
   }
   else
   {
      while(t<0)
      //for(i=t;i<0;i++)
      {
         dec_temp=dec%10;
         dec=dec/10;
         if(dec2<0)
         {
            asm mov al,dec_temp
            asm not al
            asm inc al
            asm mov dec_temp,al
         }
         if(t>-3)
         {
            gotoxy_g(x+2,y);
            printf_g(attr,dec_temp+0x30);
            x--;
         }
         t++;
      }
   }
      gotoxy_g(x+2,y);
      printf_g(attr,0x2E);
      if(dec==0)
      {
         x--;
         gotoxy_g(x+2,y);
         printf_g(attr,0x30);
      }
      while(dec!=0)
      {
         dec_temp=dec%10;
         dec=dec/10;
         gotoxy_g(x+1,y);
         if(dec2<0)
         {
            asm mov al,dec_temp
            asm not al
            asm inc al
            asm mov dec_temp,al
         }
         printf_g(attr,dec_temp+0x30);
         x--;
         j++;
      }
      gotoxy_g(x+1,y);
      if(dec2<0)
      printf_g(attr,0x2D);
      else
      printf_g(attr,0x2B);
      //gotoxy_g(x-1,y);
      /*if(dec2<0)
      {
         asm mov al,dec_temp
         asm not al
         asm inc al
         asm mov dec_temp,al
      }
      printf_g(attr,dec_temp+0x30);


      dec_temp=(dec2/pow_g(10,j-2))%10;
      gotoxy_g(x+1,y);
      if(dec2<0)
      {
         asm mov al,dec_temp
         asm not al
         asm inc al
         asm mov dec_temp,al
      }
      printf_g(attr,dec_temp+0x30);
      dec_temp=(dec2/pow_g(10,j-3))%10;
      gotoxy_g(x+2,y);
      if(dec2<0)
      {
         asm mov al,dec_temp
         asm not al
         asm inc al
         asm mov dec_temp,al
      }
      printf_g(attr,dec_temp+0x30);*/
}
void hputs_g(int x,int y,int attr,unsigned long dec,unsigned char t) //Gigabyte puts Hex function
{
   int i;
   unsigned char dec_temp;
   for(i=t;i>=1;i--)
   {
      dec_temp=dec%16;
      dec=dec/16;
      if(dec_temp<10)
      {
         dec_temp+=0x30;
      }
      else
      {
         dec_temp+=0x41-10;
      }
      gotoxy_g(x+i-1,y);
      printf_g(attr,dec_temp);
   }
}
void clrscr_g(char xs,char ys,char xd,char yd) //Gigabyte clrscr function
{
        int i,j;

        for(i=ys;i<=yd;i++)
                for(j=xs;j<=xd;j++)
                        cputs_g(j,i,0x07," ");
}
/*void Input_File()
{
   unsigned char x,y,temp;
   for(x=8;x>0;x--)
   {
      asm mov ah,01h
      asm int 21h
      asm mov temp,al
      FileName[8-x]=temp;
   }
   printf_g(0x07,0x2E);
   FileName[8]=0x2E;
   asm mov ah,03h
   asm mov bh,00h
   asm int 10h
   asm mov y,dh
   asm mov x,dl
   gotoxy_g(x+2,y+1);
   for(x=3;x>0;x--)
   {
      asm mov ah,01h
      asm int 21h
      asm mov temp,al
      FileName[12-x]=temp;
   }
}*/
