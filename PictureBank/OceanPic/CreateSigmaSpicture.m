ListBathy=[ -165 -137 -117 -86 -75 -65 -57 -51 -48];
MinBathy=min(ListBathy(:));
nbPt=size(ListBathy,2);
siz=100;
bathydelt=10;

N=10;
theta_s=3;
theta_b=0;
[Sc_w, Cs_w, Sc_r, Cs_r]=GRID_GetSc_Cs(N, theta_s, theta_b);
h=0.5;
TheColor=[h h h]; % it is grey

%
% preliminary data creation
% 

ListPtX=zeros(0,1);
ListPtY=zeros(0,1);
nb=0;
for iPt=1:nbPt
  nb=nb+1;
  ListPtX(1,nb)=(iPt-1)*siz;
  ListPtY(1,nb)=ListBathy(1,iPt)*siz;
end;
nb=nb+1;
ListPtX(1,nb)=(nbPt-1)*siz;
ListPtY(1,nb)=(MinBathy-bathydelt)*siz;

nb=nb+1;
ListPtX(1,nb)=0;
ListPtY(1,nb)=(MinBathy-bathydelt)*siz;


%
%   first picture
%
hold on;
axis off;
line([0, (nbPt-1)*siz], [0, 0], 'color', 'black');

for iPt=1:nbPt
  for iN=1:N
    fact1=(iN-1)/N;
    fact2=iN/N;
    if (iPt < nbPt)
      line([(iPt-1)*siz, iPt*siz], ...
	   [fact1*ListBathy(1,iPt)*siz, fact1*ListBathy(1,iPt+1)*siz], ...
	   'color', 'black', ...
	   'linestyle', '-');
    end;
    line([(iPt-1)*siz, (iPt-1)*siz], ...
	 [fact1*ListBathy(1,iPt)*siz, fact2*ListBathy(1,iPt)*siz], ...
	 'color', 'black', ...
	 'linestyle', '-');
  end;
%  line([(iPt-1)*siz, iPt*siz], ...
%       [0, 0]);
end;
fill(ListPtX, ListPtY, TheColor);
FileSigma='PictureSigmaCoord.eps';
saveas(gcf, FileSigma);
hold off;
%keyboard;
clf;


%
%   first picture
%
hold on;
axis off;
line([0, (nbPt-1)*siz], [0, 0], 'color', 'black');

RealCs=zeros(1,N+1)
RealCs(1,1)=-1;
RealCs(1,2:N+1)=Cs_w(1,:);

for iPt=1:nbPt-1
  for iN=1:N
    fact1=-RealCs(1,iN);
    fact2=-RealCs(1,iN+1);
    if (iPt < nbPt)
      line([(iPt-1)*siz, iPt*siz], ...
	   [fact1*ListBathy(1,iPt)*siz, fact1*ListBathy(1,iPt+1)*siz], ...
	   'color', 'black', ...
	   'linestyle', '-');
    end;
    line([(iPt-1)*siz, (iPt-1)*siz], ...
	 [fact1*ListBathy(1,iPt)*siz, fact2*ListBathy(1,iPt)*siz], ...
	 'color', 'black', ...
	 'linestyle', '-');
  end;
%  line([(iPt-1)*siz, iPt*siz], ...
%       [0, 0]);
end;
fill(ListPtX, ListPtY, TheColor);
FileSigma='PictureSCoord.eps';
saveas(gcf, FileSigma);
hold off;
clf;
