f = fieldnames(a);%a中所有表的名字，后面用来调用a中的每个表
ex = a.(f{1})(1,2:end)';%获取激发波长ex
em = a.(f{1})(2:end,1);%获取发射波长em
for i = 2:length(f) %第一个是空白，从2开始
    a.(f{i})(2:end,2:end) = a.(f{i})(2:end,2:end) - a.(f{1})(2:end,2:end);%将每个样都扣除空白
    X(i-1,:,:) = a.(f{i})(2:end,2:end);%构建三维数组，把所有样本合并到一起
end
X(X < 0) = 0;%减去空白后，将可能出现的负值全部变成0

OriginalData= struct('Ex',ex,'Em',em,'X',X,'nSample',size(X,1),'nEx',size(X,3),'nEm',size(X,2),'XBackup',X);%构建数据集，数据全部导入
clearvars -except OriginalData %清除掉多余的变量，只留下导入的数据

trimdata=subdataset(OriginalData,[],OriginalData.Em>500,OriginalData.Ex<200);
trimdata=subdataset(trimdata,[],trimdata.Em<250,trimdata.Ex<200);
trimdata = EEMCut(trimdata,-0,NaN,NaN,NaN,'No');
Xs=smootheem(trimdata,[ ],[],[],[],[],[],'');
X=Xs.X;
X(isnan(X))=0;
ex=Xs.Ex;em=Xs.Em;
dex=ex(2)-ex(1);dem=em(2)-em(1);

[P] = mFRI(Xs,[2 3])%荧光区域积分

for i=1:54
    ts=squeeze(X(i,:,1:11));
    UVAem(i)=(sum(ts(:))-0.5*(sum(ts(1,:))+sum(ts(:,1))+sum(ts(end,:))+sum(ts(:,end)))+0.25*(ts(1,1)+ts(1,end)+ts(end,1)+ts(end,end)))*dex*dem;
end

abs = xlsread('absorbance1.csv');
abs = abs(:,3:56);

for i = 1:size(abs,2)
    UVAex(i) = (sum(abs(1:50,i))+0.5*abs(51,i));
    Qex(i) = UVAem(i)/(UVAex(i)*sum(em));
end

result_Qex = [UVAem;UVAex;Qex]
xlswrite('result_Qex.xlsx',result_Qex)

