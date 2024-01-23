cd 文件所在目录
a = importdata('dt.xlsx');
f = fieldnames(a);%a中所有表的名字，后面用来调用a中的每个表
ex = a.(f{1})(1,2:end)';%获取激发波长ex
em = a.(f{1})(2:end,1);%获取发射波长em
for i = 2:length(f) %第一个是空白，从2开始
    a.(f{i})(2:end,2:end) = a.(f{i})(2:end,2:end) - a.(f{1})(2:end,2:end);%将每个样都扣除空白
    X(i-1,:,:) = a.(f{i})(2:end,2:end);%构建三维数组，把所有样本合并到一起
end
X(X < 0) = 0;%减去空白后，将可能出现的负值全部变成0

w350 = a.(f{1})(2:end,a.(f{1})(1,:)==350);
Em = a.(f{1})(2:end,1);%取出所有Em值
im = 1:length(Em);%给每个Em编号
em1 = min(im(Em >= 371));%获取下限编号
em2 = max(im(Em <= 428));%获取上限编号
q = 0;
for i = em1:em2-1
    q = q+(w350(i)+w350(i+1))*5/2;%我这里间隔是5，你们可以根据自己的数据改
end

X = X/q;

OriginalData= struct('Ex',ex,'Em',em,'X',X,'nSample',size(X,1),'nEx',size(X,3),'nEm',size(X,2),'XBackup',X);%构建数据集，数据全部导入
clearvars -except OriginalData %清除掉多余的变量，只留下导入的数据

%EEMCut(OriginalData,-0,NaN,NaN,NaN,'No');

trimdata=subdataset(OriginalData,[],OriginalData.Em>550,OriginalData.Ex<200);
%Xs=smootheem(trimdata,[15 15],[15 15],[17 18],[19 18],[1 1 1 1],[],'');
Xs=smootheem(trimdata,[ ],[],[],[],[],[],'');
peaklist=pickpeaks(Xs);  %Xs是要与上面的对应
writetable(peaklist,'peaklist.xlsx','WriteVariableNames',true);  %  将绘制的指数数

eemview(Xs,'X',[2 3],[],[],[],[],[],'colorbar',[],'big');

[P] = FRI(Xs,[2 3])%荧光区域积分
[P_mFRI] = mFRI(Xs,[2 3])%荧光区域积分

xlswrite('FRI.xlsx',P)

Test1=outliertest(Xs,[],2:6,'nonnegativity');
DSsplit=splitds(Xs,[],4,'random',{[1 2],[3 4]}); %固定运行程序，不用更改任何数
splitmodels=splitanalysis(DSsplit,2:6, 40, 'nonnegativity', 1e-8);
val_results=splitvalidation(splitmodels,3);  
LSmodel=randinitanal(Xs,2:5,100,'nonnegativity', 1e-8);  %主要是进行3组分
val_results=splitvalidation(splitmodels,3,[],[],LSmodel);  
[FMax,B,C] = modelout(val_results,3,'LXY_3_validated.xlsx');  %将最后的4组分




z = fingerprint(LSmodel,3);%组分数据导出
%从组分的fig图像开始，导出组分数据
a = open('3comp.fig');
b = get(a,'Children');
c = get(b,'Children');
x = get(c{1,1},'Xdata');
y = get(c{1,1},'Ydata');
z = get(c{1,1},'Zdata');
%改成这样
xdata = get(c{1,1},'Xdata');
ydata = get(c{1,1},'Ydata');
for i = 1:length(c)
    zdata{i,1} = get(c{i,1},'Zdata');
end

% comparison
openfluor(val_results,3,'LXY_3_validated_model.txt') 
openfluormatches('D:\demofiles\OpenFluorSearch____20220123.csv')
