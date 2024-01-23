function [P, Phi, MF] = FRI(data,plots)
% FRI：区域积分计算
% Phi：各区域的荧光积分，MF：倍增系数，P：各区域比例
% data：数据集，plots：每次画图数，如[2,3]表示两行三列图，即一次六张图，默认不连续出图而是按下任意键画下一组图
% e.g.绘制图形:[P, Phi, MF] = FRI(data,plots)    不绘制图形:[P, Phi, MF] = FRI(data)
% 只获取各区域积分比例:[P] = FRI(data)

zmin=min(reshape(data.X,(data.nSample*data.nEm*data.nEx),1));
zmax=max(reshape(data.X,(data.nSample*data.nEm*data.nEx),1));

X=data.X;
X(isnan(X))=0;
ex=data.Ex;em=data.Em;
dex=ex(2)-ex(1);dem=em(2)-em(1);

s(1)=(ex(end)-ex(1))*(370-em(1));index{1,1}=find(ex>=ex(1)&ex<=ex(end));index{1,2}=find(em<=370);
s(2)=(240-ex(1))*(em(end)-370);index{2,1}=find(ex<=240);index{2,2}=find(em>370);
s(3)=(260-240) *(em(end)-370); index{3,1}=find(ex>240&ex<=260);index{3,2}=find(em>370);
s(4)=(ex(end)-260)* (em(end)-370);index{4,1}=find(ex>260);index{4,2}=find(em>370);
for i=1:data.nSample
    t=squeeze(X(i,:,:));
    for j=1:4
        ts=t(index{j,2},index{j,1});
        Phi(i,j)=(sum(ts(:))-0.5*(sum(ts(1,:))+sum(ts(:,1))+sum(ts(end,:))+sum(ts(:,end)))+0.25*(ts(1,1)+ts(1,end)+ts(end,1)+ts(end,end)))*dex*dem;
        MF(i,j)=sum(s)/s(j);
        S(i,j)= Phi(i,j)*MF(i,j);
    end
    for j=1:4
        P(i,j)=S(i,j)/sum(S(i,:));
    end
end
if nargin>1
    figure
    for i=1:(plots(1)*plots(2)):data.nSample,pause
        m=min(i+plots(1)*plots(2)-1,data.nSample)-i+1;
        for j=1:m
            subplot(plots(1),plots(2),j)
            contourf(em,ex,squeeze(X(i+j-1,:,:))'),colorbar,caxis([zmin,zmax])
            line([370 370],[ ex(1) ex(end)],'color','k','LineWidth',0.8)
            line([370 em(end)],[240 240],'color','k','LineWidth',0.8)
            line([370 em(end)],[260 260],'color','k','LineWidth',0.8)
            text((370+em(1))/2,( ex(1)+ex(end))/2,'Ⅰ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((370+em(end))/2,(240+ex(1))/2,'Ⅱ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((370+em(end))/2,(240+260)/2,'Ⅲ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            text((370+em(end))/2,(260+ex(end))/2,'Ⅳ','Color','white','FontSize',12,'FontAngle','italic','FontWeight','bold','HorizontalAlignment','center')
            
            xlabel('Em/nm')
            ylabel('Ex/nm')
            title(['Sample' num2str(i+j-1)])
        end
    end
end
end
