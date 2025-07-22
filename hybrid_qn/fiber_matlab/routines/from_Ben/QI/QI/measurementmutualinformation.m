function [params,poop] = measurementmutualinformation(rho)
%measurement carried out on 1st qubit. 


S=partialTr_slow(rho,[2,2],1);%state of second qubit - system 1 is traced out
%OPTIONS = OPTIMSET('TolX',1e-8);
[params,error]=fminsearch('parp',rand(3,1),optimset('TolX',1e-16,'TolFun',1e-14,'MaxFunEvals',1000,'MaxIter',1000),rho);%minimised entropy of system 2 after measurements on system 1
poop = quantumentropy(S)-error; 
%first term is entropy of system 2.
%error is minimum entropy of system 2 after measurement of system 1. 
%Poop = entropy of system 2 (after simply tracing out system 1) MINUS entropy of system 2 after projecting system 1 out. 

