clear all;
close all;

img=imread("/home/redouane/Documents/L3/S6/TIA/TD/ED_3_6_originale.png");
imshow(img);
colorbar();

sizeImg = size(img);
NL=sizeImg(1,1);
NC=sizeImg(1,2);

tab=zeros(2,256); %tab de niveaux de gris
tab(1,1:256)=0:255;

%remplissage tab niveaux de gris
%et affichage de l'histogramme
for y=1:NL
    for x= 1:NC
        val=img(y,x);
        tab(2,val+1)=tab(2,val+1)+1;
    end
end

ticktab=zeros(1,25);

for i=1:25
    ticktab(1, i)=10*i;
end

figure(2);
plot(tab(1, 1:256),tab(2, 1:256));
set(gca,'XTick',ticktab(1, 1:25));
xlim([0, 255]);
%seuillage de l'img
figure(3);
imgSeuil=img;
for y=1:NL
    for x= 1:NC
        val=imgSeuil(y,x);
        if(val<30)
            imgSeuil(y,x)=0;
        else
            imgSeuil(y,x)=255;
        end
    end
end
imgSeuil=~imgSeuil;%inversion pour lignes blanches
imshow(imgSeuil);

%squelettisation: cf Zhang Suen algorithm sur rosetta code
%%%--------------

stopCond = 1;

%while (stopCond>0)
for i=1:10
  tic = clock();
  stopCond = 0;
  
  ap1 = 0;
  bp1 = 0;
  tabPixel = []; %zeros(2, NL*NC);
  %tmp = 1;
  for x=2:NL-1
      for y= 2:NC-1
        p1 = imgSeuil(x,y);  %les voisins du pixel
        p2 = imgSeuil(x-1, y);
        p3 = imgSeuil(x-1, y+1);
        p4 = imgSeuil(x, y+1);
        p5 = imgSeuil(x+1, y+1);
        p6 = imgSeuil(x+1, y);
        p7 = imgSeuil(x+1, y-1);
        p8 = imgSeuil(x, y-1);
        p9 = imgSeuil(x-1, y-1);
        
        tabNeighbour = [p2, p3, p4, p5, p6, p7, p8, p9];
        tmpTabl = diff([tabNeighbour, p2]);
        tmpTabl = max(tmpTabl, 0);
        
        ap1 = sum(tmpTabl);
        bp1 = sum(tabNeighbour);

        if((p1==1)&&(bp1>=2)&&(bp1<=6)&&(ap1==1)&&
          ((p2==0)||(p4==0)||(p6==0))&&
          ((p4==0)||(p6==0)||(p8==0)))
            tabPixel = [tabPixel,[x; y]];
            stopCond += 1;
          endif
      endfor
  endfor

  for i=2:columns(tabPixel)
    imgSeuil(tabPixel(1, i), tabPixel(2, i)) = 0;
  endfor

  ap1 = 0;
  bp1 = 0;
  tabPixel = [];

  for x=2:NL-1
      for y= 2:NC-1
        p1 = imgSeuil(x,y);
        p2 = imgSeuil(x-1, y);
        p3 = imgSeuil(x-1, y+1);
        p4 = imgSeuil(x, y+1);
        p5 = imgSeuil(x+1, y+1);
        p6 = imgSeuil(x+1, y);
        p7 = imgSeuil(x+1, y-1);
        p8 = imgSeuil(x, y-1);
        p9 = imgSeuil(x-1, y-1);
        tabNeighbour = [p2, p3, p4, p5, p6, p7, p8, p9];
        ap1 = sum(diff([tabNeighbour, p2]));
        bp1=sum(tabNeighbour);
          if((p1==1)&&(bp1>=2)&&(bp1<=6)&&(ap1==1)&&
          ((p2==0)||(p4==0)||(p8==0))&&
          ((p2==0)||(p6==0)||(p8==0)))
            tabPixel=[tabPixel, x; y];
            stopCond += 1;
          endif
      endfor
  endfor

  for i=1:columns(tabPixel)
    imgSeuil(tabPixel(1, i), tabPixel(2, i))=0;
  endfor
  toc = clock();
  elapsed_time += etime(toc, tic);
  
%endwhile
endfor
disp(elapsed_time/10);%mean exec time for 10 iter

figure(4);
imshow(imgSeuil);

%%%-------------

##tabSquel=zeros(1,10);
##hold on;
##for y=2:NL-1
##        for x= 2:NC-1
##            % on utilise ces valeurs pour ne pas acceder aux bords de l'image
##            %Pixel1 (P1) correspond à imgSeuil(y,x), c'est le pixel du milieu et on etudie ses voisins
##            A=0;%nombre de transi de 0 à 1
##            B=0;%nombre de voisins
##            
##            tabSquel(1,2)=imgSeuil(y,x);%p1
##            tabSquel(1,2)=imgSeuil(y-1,x);%p2
##            tabSquel(1,3)=imgSeuil(y-1,x+1);%p3
##            tabSquel(1,4)=imgSeuil(y,x+1);%p4
##            tabSquel(1,5)=imgSeuil(y+1,x+1);%p5
##            tabSquel(1,6)=imgSeuil(y+1,x);%p6
##            tabSquel(1,7)=imgSeuil(y+1,x-1);%p7
##            tabSquel(1,8)=imgSeuil(y,x-1);%p8
##            tabSquel(1,9)=imgSeuil(y-1,x-1);%p9
##            tabSquel(1,10)=imgSeuil(y-1,x);
##
##
##sum = (0.5*(abs(tabSquel(1,6)-tabSquel(1,1)) + abs(tabSquel(1,7)-tabSquel(1,6)) + abs(tabSquel(1,8)-tabSquel(1,7)) + abs(tabSquel(1,9)-tabSquel(1,8)) + abs(tabSquel(1,2)-tabSquel(1,9)) + abs(tabSquel(1,3)-tabSquel(1,2)) + abs(tabSquel(1,4)-tabSquel(1,3)) + abs(tabSquel(1,5)-tabSquel(1,4))));
##          if(sum==3)
##              plot(y,x, "ro-");
##          end
##    end
##end
%imshow(imgSeuil);
