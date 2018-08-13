p = 3;
m = 5;
global generator_poly
generator_poly = [2,0,1,2,1,1];
global prim_poly
prim_poly = [1 2 0 0 0 1];
global field
field = gftuple([-1:p^m-2]',prim_poly,p);
% 22 is root of prim_poly

% example
message = [0 1 2 0 1 1];
encoded_11 = g11_encode(message);
% without perturbance
decoded_message = g11_decode(encoded_11);
symerr(message,decoded_message)
% with one perturbance
encoded_11_copy = encoded_11;
encoded_11_copy(randi(11)) = mod(encoded_11_copy(randi(11))+randi(2),3);
decoded_message = g11_decode(encoded_11_copy);
symerr(message,decoded_message)
% with two perturbance
two_positions = randi(11,[1,2]);
while(two_positions(1)==two_positions(2))
    two_positions = randi(11,[1,2]);
end
encoded_11(two_positions(1)) = mod(two_positions(1)+randi(2),3);
encoded_11(two_positions(2)) = mod(two_positions(2)+randi(2),3);
decoded_message = g11_decode(encoded_11);
symerr(message,decoded_message)

