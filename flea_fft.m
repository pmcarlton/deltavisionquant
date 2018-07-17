fi-=fi;
  th=0;
  r=0;
  for l=1:200;
  li=sqrt(220-l);
  if(r<li),r=r+li;
  end;
  offsetx=r.*cos(th);
offsety=r.*sin(th);
fi=fi|circshift(b,floor([offsetx offsety]))|circshift(b,floor([-offsetx -offsety]));
th=th+0.51;
r=r+17;
if(r>128),r-=128;
end;
fim=abs(ifft2(af.*fftshift(fi)));
fim-=min(fim(:));
fim.*=(255./max(fim(:)));
fn=strcat('2hookeflea',num2str(l),'.tif');
imwrite(fn,[cc.*fi.*255 fim]);
disp(l);
end

