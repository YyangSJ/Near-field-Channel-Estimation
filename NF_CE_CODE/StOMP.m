function [ theta ] = StOMP( y,A,S,ts )
%CS_StOMP Summary of this function goes here
%Version: 1.0 written by jbb0523 @2015-04-29
%   Detailed explanation goes here
%   y = Phi * x
%   x = Psi * theta
%	y = Phi*Psi * theta
%   �� A = Phi*Psi, ��y=A*theta
%   S is the maximum number of StOMP iterations to perform
%   ts is the threshold parameter
%   ������֪y��A����theta
%   Reference:Donoho D L��Tsaig Y��Drori I��Starck J L��Sparse solution of
%   underdetermined linear equations by stagewise orthogonal matching 
%   pursuit[J]��IEEE Transactions on Information Theory��2012��58(2)��1094��1121
    if nargin < 4
        ts = 2.5;%ts��Χ[2,3],Ĭ��ֵΪ2.5
    end
    if nargin < 3
        S = 10;%SĬ��ֵΪ10
    end
    [y_rows,y_columns] = size(y);
    if y_rows<y_columns
        y = y';%y should be a column vector
    end
    [M,N] = size(A);%���о���AΪM*N����
    theta = zeros(N,1);%�����洢�ָ���theta(������)
    Pos_theta = [];%�������������д洢A��ѡ��������
    r_n = y;%��ʼ���в�(residual)Ϊy
    for ss=1:S%������S��
        product = A'*r_n;%���о���A������в���ڻ�
        sigma = norm(r_n)/sqrt(M);%�μ��ο����׵�3ҳRemarks(3)
        Js = find(abs(product)>ts*sigma);%ѡ��������ֵ����
        Is = union(Pos_theta,Js);%Pos_theta��Js����
        if length(Pos_theta) == length(Is)
            if ss==1
                theta_ls = 0;%��ֹ��1�ξ���������theta_ls�޶���
            end
            break;%���û���µ��б�ѡ��������ѭ��
        end
        %At������Ҫ������������Ϊ��С���˵Ļ���(�������޹�)
        if length(Is)<=M
            Pos_theta = Is;%��������ż���
            At = A(:,Pos_theta);%��A���⼸����ɾ���At
        else%At�����������������б�Ϊ������ص�,At'*At��������
            if ss==1
                theta_ls = 0;%��ֹ��1�ξ���������theta_ls�޶���
            end
            break;%����forѭ��
        end
        %y=At*theta��������theta����С���˽�(Least Square)
        theta_ls = (At'*At)^(-1)*At'*y;%��С���˽�
        %At*theta_ls��y��At�пռ��ϵ�����ͶӰ
        r_n = y - At*theta_ls;%���²в�
        if norm(r_n)<1e-6%Repeat the steps until r=0
            break;%����forѭ��
        end
    end
    theta(Pos_theta)=theta_ls;%�ָ�����theta
end 