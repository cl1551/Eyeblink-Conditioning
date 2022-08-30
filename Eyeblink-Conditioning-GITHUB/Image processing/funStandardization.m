function StandFrameData = funStandardization(frameData, maxFactor, minFactor)
    for x = 1:1:length(frameData)
        StandFrameData(x) = 100 * (frameData(x) - minFactor) / (maxFactor - minFactor);
    end
end