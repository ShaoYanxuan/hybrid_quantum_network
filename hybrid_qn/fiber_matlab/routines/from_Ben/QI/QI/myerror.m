function myerror(str)


global OuputToFig;
global LabFid;


if(OuputToFig)
   errordlg(str);
else
	error(str);   
end;

if(LabFid>0)
   fprintf(LabFid,'%s\n',str);
end;
