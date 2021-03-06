function [subh, h, H, subH] = H_4_4(xg, t, nk, nx)
X_0 = xg(1);
Y_0 = xg(2);
Vx = xg(3);
Vy = xg(4);


h = zeros(nk, nx);
H = zeros(nk, 4, nx);
subH = zeros(nk*nx, 4);
subh = zeros(nk*nx, 1);

for j=1:nk
    delta_y1 = (4.1e5 - X_0 - t(j)*Vx);
    delta_y2 = (Y_0 + t(j)*Vy - 4.9*t(j)^2);
    delta_y3 = (4.4e5 - X_0 - t(j)*Vx);
    
    h(j, 1:2) = [sqrt(delta_y1^2 + delta_y2^2); sqrt(delta_y3^2 + delta_y2^2)];

    % order is time (j), dx_i, h_k    i=1,2,3,4; k=1,2
    H(j, 1, 1:2) = [-delta_y1/h(j, 1); -delta_y3/h(j, 2)];
    H(j, 2, 1:2) = [delta_y2/h(j, 1); delta_y2/h(j, 2)];
    H(j, 3, 1:2) = [-t(j)*delta_y1/h(j, 1); -t(j)*delta_y3/h(j, 2)];
    H(j, 4, 1:2) = [t(j)*delta_y2/h(j, 1); t(j)*delta_y2/h(j, 2)];
    
    
    % extension part
    % see notes for the equations
    if nx > 2
        % there are now more h equations so k=1,2,3,4
        h(j, 3:4) = [atan2(delta_y2, delta_y1); atan2(delta_y2, delta_y3)];
        
        H(j, 1, 3:4) = [-delta_y2/(h(j, 1))^2*(-1); -delta_y2/(h(j, 2))^2*(-1)];
        H(j, 2, 3:4) = [-delta_y1/(h(j, 1))^2; -delta_y3/(h(j, 2))^2];
        H(j, 3, 3:4) = [delta_y2/(h(j, 1))^2*t(j); delta_y2/(h(j, 2))^2*t(j)];
        H(j, 4, 3:4) = [delta_y1/(h(j, 1))^2*t(j); delta_y3/(h(j, 2))^2*t(j)];
    
    end
    
end

subH = [squeeze(H(:, :, 1)); squeeze(H(:, :, 2))];
subh = [h(:, 1); h(:, 2)];

if nx > 2
    subH = [squeeze(H(:, :, 1)); squeeze(H(:, :, 2)); squeeze(H(:, :, 3)); squeeze(H(:, :, 4))];
    subh = [h(:, 1); h(:, 2); h(:, 3); h(:, 4)];
end

end
