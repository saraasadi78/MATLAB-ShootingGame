error_margin = 0.25;
rounds = 5;
score = 0;

bg = imread('A_high-resolution_astrophotograph_showcases_a_spir.png');
bg_resized = imresize(bg, [500 500]); % Resize for consistent plotting

figure('Name', 'Galactic Target Shooting', 'NumberTitle', 'off');

log = struct('round', {}, 'attempt', {}, 'target_x', {}, 'target_y', {}, ...
             'shoot_x', {}, 'shoot_y', {}, 'hit', {});

for i = 1:rounds
    cla;
    % Display galaxy image as background
    imagesc([0 10], [0 10], flipud(bg_resized));
    set(gca, 'YDir', 'normal'); % Correct orientation
    axis manual;
    xlim([0 10]);
    ylim([0 10]);
    xlabel('X');
    ylabel('Y');
    grid on;
    hold on;

    % Generate target
    target_x = rand * 10;
    target_y = rand * 10;
    plot(target_x, target_y, 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    title(['Round ' num2str(i) ': Shoot!']);

    % First shot
    disp(['Round ' num2str(i) ', Attempt 1']);
    [shoot_x, shoot_y] = ginput(1);
    plot(shoot_x, shoot_y, 'bp', 'MarkerSize', 18, 'LineWidth', 2);
    text(shoot_x + 0.2, shoot_y + 0.2, 'Shot 1', 'Color', 'b', 'FontSize', 10, 'FontWeight', 'bold');
    dist1 = abs(shoot_x - target_x) + abs(shoot_y - target_y);
    is_hit1 = dist1 < error_margin;

    % Log first attempt
    log(end+1) = struct('round', i, 'attempt', 1, ...
        'target_x', target_x, 'target_y', target_y, ...
        'shoot_x', shoot_x, 'shoot_y', shoot_y, ...
        'hit', is_hit1);

    if is_hit1
        score = score + 1;
        title('Hit on first try!', 'Color', 'g');
        disp('Hit on first try!');
    else
        % Second shot
        title('Miss! Try again.', 'Color', 'r');
        disp('Miss! Try again.');
        [shoot_x2, shoot_y2] = ginput(1);
        plot(shoot_x2, shoot_y2, 'mp', 'MarkerSize', 18, 'LineWidth', 2);
        text(shoot_x2 + 0.2, shoot_y2 + 0.2, 'Shot 2', 'Color', 'm', 'FontSize', 10, 'FontWeight', 'bold');
        dist2 = abs(shoot_x2 - target_x) + abs(shoot_y2 - target_y);
        is_hit2 = dist2 < error_margin;

        % Log second attempt
        log(end+1) = struct('round', i, 'attempt', 2, ...
            'target_x', target_x, 'target_y', target_y, ...
            'shoot_x', shoot_x2, 'shoot_y', shoot_y2, ...
            'hit', is_hit2);

        if is_hit2
            score = score + 1;
            title('Hit on second try!', 'Color', 'g');
            disp('Hit on second try!');
        else
            title('Missed both attempts.', 'Color', 'r');
            disp('Missed both attempts.');
        end
    end
    pause(1.5);
end

% Final Score and Summary
cla;
imagesc([0 10], [0 10], flipud(bg_resized));
set(gca, 'YDir', 'normal');
axis manual;
xlim([0 10]);
ylim([0 10]);
xlabel('X');
ylabel('Y');
title(['Game Over! Score: ' num2str(score) ' / ' num2str(rounds)], 'FontSize', 14, 'Color', 'b');
hold on;

% Plot all shots and targets
for k = 1:length(log)
    if log(k).hit
        marker = 'g*';
    else
        marker = 'rx';
    end
    plot(log(k).shoot_x, log(k).shoot_y, marker, 'MarkerSize', 10, 'LineWidth', 1.5);
    plot(log(k).target_x, log(k).target_y, 'ko', 'MarkerSize', 6);
end
legend('Shots', 'Targets');

