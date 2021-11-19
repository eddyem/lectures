% three_s.m
% [ X sigma ] = three_s(x, n)
% Производит отбор выборки x с соответствующими частотами n
% при помощи критерия "трех сигм"
% результат: среднее значение X и его среднеквадратичное отклонение, sigma

function [ X sigma ] = three_s(x, n)
newx = []; % вспомогательный массив
Data = [x ; n]; % совмещенный массив данных
X = sum(x.*n)/sum(n); % среднее арифметическое
sigma = sqrt(sum(n.*(x-X).^2)/sum(n)); % среднеквадратичное отклонение
down = X-3*sigma; % нижняя граница доверительного интервала
up = X+3*sigma;   % верхняя граница -//-
a = find(x < down); % a и b - массив координат, выходящих за границы
b = find(x > up);
while (length(a) > 0) || (length(b) > 0) % пока есть неверные значения
	Data = Data(:, find(Data(1, find(Data(1,:) >= down)) <= up)); % выбрасываем их
	x = Data(1,:);
	n = Data(2,:);
	X = sum(x.*n)/sum(n);
	for a = [1:length(n)]
		newx = [newx ones(1,n(a)).*x(a)];
	endfor
	X = median(newx);
	sigma = sqrt(sum(n.*(x-X).^2)/sum(n));
	down = X-3*sigma;
	up = X+3*sigma;
	a = find(x < down);
	b = find(x > up);
endwhile
endfunction
