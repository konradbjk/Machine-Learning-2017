function R = satisfies(h,x)
%Function should return true if the hypothesis satisfies training element x
%false otherwise   

R = true;
   m = length(h);
   for i=1:m
      if (h(i) == 0) || (x(i) != h(i) && h(i) != Inf)
        R = false;
        break;
      end
   end


end

