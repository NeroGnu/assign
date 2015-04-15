function [assign_result, sum_result] = BG_Assign(ematrix)

ematrix_b = ematrix;
[numRows, numCols] = size(ematrix);
assign_result = zeros(numRows, numCols);
anti_assign_result = ones(numRows, numCols);
round = fix(numRows/numCols);

for j = 1:round
    for i = (j*numCols):((j + 1)*numCols)
        if 0 ~= max(max(ematrix))
            [index_i, index_j] = find(ematrix == max(max(ematrix)));
            assign_result(index_i, index_j) = 1;
            anti_assign_result(index_i, :) = 0;
            ematrix(index_i, :) = 0;
            ematrix(:, index_j) = 0;
        end
    end
    ematrix = ematrix_b;
    ematrix = anti_assign_result .* ematrix;
end

round = mod(numRows, numCols);

for i = 1:round
    if 0 ~= max(max(ematrix))
        [index_i, index_j] = find(ematrix == max(max(ematrix)));
        assign_result(index_i, index_j) = 1;
        anti_assign_result(index_i, :) = 0;
        ematrix(index_i, :) = 0;
        ematrix(:, index_j) = 0;
    end
end

ematrix_b = assign_result .* ematrix_b;
sum_result = sum(sum(ematrix_b));