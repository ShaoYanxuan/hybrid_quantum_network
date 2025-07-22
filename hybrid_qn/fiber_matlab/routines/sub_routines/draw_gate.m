function y = draw_gate(gate, fig, col) 
h = figure(fig);
hold on
line([gate(1) gate(1)],h.CurrentAxes.YLim, 'Color',col, 'LineWidth', 2)
line([gate(2) gate(2)],h.CurrentAxes.YLim,'LineStyle','--','Color',col, 'LineWidth', 2)