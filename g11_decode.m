function code6 = g11_decode(code11)
global field
% compute s3
s3 = -Inf; % zero
s4 = -Inf;
s5 = -Inf;
for i=1:11
    if(code11(i) == 1)
        s3 = gfadd(s3,mod((i-1)*66,242), field);
        s4 = gfadd(s4,mod((i-1)*88,242), field);
        s5 = gfadd(s5,mod((i-1)*110,242), field);        
    elseif(code11(i) == 2)
        s3 = gfsub(s3,mod((i-1)*66,242), field);
        s4 = gfsub(s4,mod((i-1)*88,242), field);
        s5 = gfsub(s5,mod((i-1)*110,242), field);                
    end
end
if(s3 == -Inf)% no error occurs
    code6 = code11(6:11);
else
    % discriminant of polynomial
    A = gfsub(gfmul(s4,s4,field), gfmul(s3,s5,field),field); 
    code11_inner = code11;
    if(A== -Inf) % one error occurs
      error_position = mod(s3*4,242)/22 + 1;
      error_value = field(mod(s3+s4*2,242)+2,1);
      code11_inner(error_position) = mod(code11_inner(error_position)-error_value,3);
      code6 = code11_inner(6:11);
    else % two error occurs
        % use Chien search to find two roots
        error_position = [-Inf,-Inf];
        error_value = [-Inf, -Inf];
        root_num = 0;
        for k=0:10
            cadidate_root = mod(22*k,242);
            Sx = gfadd(s3, gfmul(s4,cadidate_root, field),field);
            Sx = gfadd(Sx, gfmul(s5, gfmul(cadidate_root, cadidate_root, field), field), field);
            root_indicator_1 = gfadd(gfmul(A, mod(5*22*k,242), field), Sx, field);
            root_indicator_2 = gfsub(gfmul(A, mod(5*22*k,242), field), Sx, field);
            if(root_indicator_1 == -Inf || root_indicator_2 == -Inf)
                error_position(root_num+1) = mod(-k,11)+1;
                if(root_indicator_1 == -Inf)
                    error_value(root_num+1) = 1;
                else
                    error_value(root_num+1) = 2;                
                end
                root_num = root_num + 1;
            end        
            if(root_num == 2)           
                break;
            end
        end
        code11_inner(error_position(1)) = mod(code11_inner(error_position(1))-error_value(1),3);
        code11_inner(error_position(2)) = mod(code11_inner(error_position(2))-error_value(2),3);
        code6=code11_inner(6:11);
    end
end
end