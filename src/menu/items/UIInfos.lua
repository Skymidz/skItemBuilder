function RageUI.Info(Title, RightText, LeftText)
    local LineCount = #RightText >= #LeftText and #RightText or #LeftText
    if Title ~= nil then
        RenderText("~h~" .. Title .. "~h~", 450 + 20 + 100, 45, 0, 0.34, 255, 255, 255, 255, 0)
    end
    if RightText ~= nil then
        RenderText(table.concat(RightText, "\n"), 450 + 20 + 100, Title ~= nil and 80 or 7, 0, 0.28, 255, 255, 255, 255, 0)
    end
    if LeftText ~= nil then
        RenderText(table.concat(LeftText, "\n"), 450 + 432 + 100, Title ~= nil and 80 or 7, 0, 0.28, 255, 255, 255, 255, 2)
    end
    RenderRectangle(450 + 10 + 100, 40, 432, Title ~= nil and 55 + (LineCount * 20) or ((LineCount + 1) * 20), 0, 0, 0, 160)
end