%% Find Threshold using Between class variance
clear all;clc;close all

% Read Image
img=imread('Plane.jpg');
temp=double(img);
% Calculate Histogram
histo=zeros(1,256);
[l,n]=size(temp);
for i=1:l
    for j=1:n
        histo(temp(i,j)+1)= histo(temp(i,j)+1)+1;   % Calculate Histogram of input image
    end
end
% find the Probability
p=histo./(l*n);
i=0:255;
% Calculate Between class variance
VARB=[];
for k=1:length(p)
    q1=(sum(p(1:k)));
    q2=(1-q1);
    m1=inv(q1)*(i(1:k)*p(1:k)');
    m2=inv(q2)*(i(k+1:length(p))*p((k+1:length(p)))');
    var1=((i(1:k)-m1).^2*p(1:k)')/q1;
    var2=((i(k+1:length(p))-m2).^2*p(k+1:length(p))')/q2;
    mg=q1*m1+q2*m2;
    varB=(q1*(mg-m1)^2)/q2;
    VARB=[VARB,varB];
end

% Plot Variance
figure,plot(VARB),grid on
[min,I]=sort(VARB,'descend');
% Find the threshold and display output
threshold=I(1);
temp(temp>threshold) = 255;
temp(temp<=threshold) = 0;
figure,imshow(img)
figure,imshow(temp)
%% Find threshold using Lambda and K and compare the values
clear all;clc;close all

% Read Image
img=imread('Plane.jpg');
temp=double(img);
% Calculate Histogram
histo=zeros(1,256);
[l,n]=size(temp);
for i=1:l
    for j=1:n
        histo(temp(i,j)+1)= histo(temp(i,j)+1)+1;   % Calculate Histogram of input image
    end
end
% find the Probability
p=histo./(l*n);
i=1:256;
% Global Mean and Variance
mg=sum(i.*p(i));
VarG=sum((i-mg).^2.*p(i));

% Calculate Between class variance
VARB=[];
for k=1:length(p)
    q1=(sum(p(1:k)));
    q2=(1-q1);
    m1=inv(q1)*(i(1:k)*p(1:k)');
    m2=inv(q2)*(i(k+1:length(p))*p((k+1:length(p)))');
    var1=((i(1:k)-m1).^2*p(1:k)')/q1;
    var2=((i(k+1:length(p))-m2).^2*p(k+1:length(p))')/q2;
    mg=q1*m1+q2*m2;
    varB=(q1*(mg-m1)^2)/q2;
    VARB=[VARB,varB];
end

% Calculate Lambda and K
for i=1:length(VARB)
    lambda(i)=VARB(i)./VarG;
end
for i=1:length(VARB)
    K(i)=VarG./(VarG-VARB(i));
end

% Find the threshold and compare the result for lambda and K
[min1,I1]=sort(lambda,'descend');
threshold1=I1(1);

[min2,I2]=sort(K,'descend');
threshold2=I2(1);
