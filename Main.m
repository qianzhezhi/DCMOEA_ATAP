clear
clc
warning('off')
con=configure();
functions=con.TestFunctions;
T_parameter=con.T_parameter;
popSize=con.popSize;


for rep=1:20
    file_MIGD = ['MIGD-', num2str(rep), '.txt'];fid_MIGD = fopen(file_MIGD,'w');
    file_MHV = ['MHV-', num2str(rep), '.txt'];fid_MHV = fopen(file_MHV,'w');
    
    for testFuncNo=1:size(functions,2)
        Problem=TestFunctions(functions{testFuncNo});
        for group=1:size(T_parameter,1)
           res=ATAP(Problem,popSize,T_parameter,group); 
           [resIGD,resHV]=computeMetrics(res);
           fprintf('\n %.3d',resIGD);
           fprintf(fid_MIGD,'%f \n',resIGD);
           fprintf(fid_MHV,'%f \n',resHV);
        end 
        
    end
    close all;
end
function [resIGD,resHV]=computeMetrics(resStruct)
     for T=1:size(resStruct,2)
        POFIter=resStruct{T}.POF_iter;
        POFbenchmark=resStruct{T}.turePOF;
        IGD_T(T)=IGD(POFIter,POFbenchmark);
        HV_T(T)=HV(POFIter,POFbenchmark);
     end
     resIGD=mean(IGD_T);
     resHV=mean(HV_T);

end