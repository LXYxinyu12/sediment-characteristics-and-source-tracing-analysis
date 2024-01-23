function [P, Phi, MF] = FRI(data,plots)
% FRI：区域积分计算
% Phi：各区域的荧光积分，MF：倍增系数，P：各区域比例
% data：数据集，plots：每次画图数，如[2,3]表示两行三列图，即一次六张图，默认不连续出图而是按任意键画下一组图
% e.g.绘制图形:[P, Phi, MF] = FRI(data,plots)    不绘制图形:[P, Phi, MF] = FRI(data)
% 只获取各区域积分比例:[P] = FRI(data)
X=data.X;
X(isnan(X))=0;
X(X<0)=0;
ex=data.Ex;em=data.Em;
disp('Data check starts.')
sz=size(X);
rsz=[data.nSample,data.nEm,data.nEx];
if ~isequal(sz,rsz)
    warning(['The shape of data.X should be ' num2str(data.nSample) '×' num2str(data.nEm) '×'...
        num2str(data.nEx) ', but now it is ' num2str(sz(1)) '×' num2str(sz(2)) '×' num2str(sz(3)) '.'])
    X=permute(X,[find(sz==rsz(1)) find(sz==rsz(2)) find(sz==rsz(3))]);
end
t1=find(ex<250,1);t2=find(em<330,1);t3=find(em>380,1);
if isempty(t1)||isempty(t2)||isempty(t3)
    error('data.Ex and data.Em should contain range: Ex below 250 nm, Em below 330 nm, Em above 380nm')
end
disp('Data check ends.')
for i=1:length(ex)
    for j=1:length(em)
        if em(j)<=ex(i)
            X(:,j,i)=0;
        end
    end
end
if em(1)<=250
    if ex(1)<=em(1)
        s(1)=(250-ex(1))*(330-em(1))-0.5*(250-em(1))^2;
    else
        s(1)=0.5*((330-250)+(330-ex(1)))*(250-ex(1));
    end
    if ex(end)>=380
        s(4)=0.5*(380-250)^2;
        s(5)=(ex(end)-250)*(em(end)-380)-0.5*(ex(end)-380)^2;
    else
        s(4)=0.5*(ex(end)-250)*(380-ex(end)+380-250);
        s(5)=(ex(end)-250)*(em(end)-380);
    end
else
    s(1)=(250-ex(1))*(330-em(1));
    if ex(end)>=380
        s(4)=0.5*(em(1)-250+380-250)*(380-em(1));
        s(5)=(ex(end)-250)*(em(end)-380)-0.5*(ex(end)-380)^2;
    else
        s(4)=(em(1)-250)*(380-em(1))+0.5*(ex(end)-em(1))*(380-ex(end)+380-em(1));
        s(5)=(ex(end)-250)*(em(end)-380);
    end
end
dex=abs(ex(2)-ex(1));dem=abs(em(2)-em(1));
index{1,1}=find(ex<=250);index{1,2}=find(em<=330);
s(2)=(250-ex(1))*(380-330);index{2,1}=find(ex<=250);index{2,2}=find(em>=330&em<=380);
s(3)=(250-ex(1))*(em(end)-380);index{3,1}=find(ex<=250);index{3,2}=find(em>=380);
index{4,1}=find(ex>=250);index{4,2}=find(em<=380);
index{5,1}=find(ex>=250);index{5,2}=find(em>=380);
for i=1:data.nSample
    t=squeeze(X(i,:,:));
    for j=1:5
        ts=t(index{j,2},index{j,1});
        Phi(i,j)=(sum(ts(:))-0.5*(sum(ts(1,:))+sum(ts(:,1))+sum(ts(end,:))+sum(ts(:,end)))+0.25*(ts(1,1)+ts(1,end)+ts(end,1)+ts(end,end)))*dex*dem;
        MF(i,j)=sum(s)/s(j);
        S(i,j)= Phi(i,j)*MF(i,j);
    end
    for j=1:5
        P(i,j)=S(i,j)/sum(S(i,:));
    end
end
if nargin>1
    figure
    for i=1:(plots(1)*plots(2)):data.nSample,pause
        m=min(i+plots(1)*plots(2)-1,data.nSample)-i+1;
        for j=1:m
            subplot(plots(1),plots(2),j)
            contourf(em,ex,squeeze(X(i+j-1,:,:))'),colorbar
            line([em(1) em(end)],[250 250],'color','k','LineWidth',0.8)
            line([380 380],[ex(1) ex(end)],'color','k','LineWidth',0.8)
            line([330 330],[ex(1) 250],'color','k','LineWidth',0.8)
            text((330+em(1))/2,(250+ex(1))/2,'Ⅰ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((330+380)/2,(250+ex(1))/2,'Ⅱ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((380+em(end))/2,(250+ex(1))/2,'Ⅲ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((em(1)+380)/2,(250+ex(end))/2,'Ⅳ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((380+em(end))/2,(250+ex(end))/2,'Ⅴ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            xlabel('Em/nm')
            ylabel('Ex/nm')
            title(['Sample' num2str(i+j-1)])
        end
    end
end
end