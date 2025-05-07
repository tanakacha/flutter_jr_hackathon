export const solution = (intervals: number[][]): number[][] => {
    if (intervals.length === 0) return [];

    // intervals を開始時間でソート
    intervals.sort((a, b) => a[0] - b[0]);

    const merged: number[][] = [];
    let currentInterval = intervals[0];

    for (let i = 1; i < intervals.length; i++) {
        const [currentStart, currentEnd] = currentInterval;
        const [nextStart, nextEnd] = intervals[i];

        if (currentEnd >= nextStart) {
            // 重複している場合、区間を統合
            currentInterval = [currentStart, Math.max(currentEnd, nextEnd)];
        } else {
            // 重複していない場合、現在の区間を結果に追加し、次の区間に進む
            merged.push(currentInterval);
            currentInterval = intervals[i];
        }
    }

    // 最後の区間を追加
    merged.push(currentInterval);

    return merged;
};
console.log(solution([[1, 3], [2, 4], [5, 7]])); // [[1, 4], [5, 7]]
console.log(solution([[1, 5], [2, 6], [8, 10], [15, 18]])); // [[1, 6], [8, 10], [15, 18]]
console.log(solution([[1, 4], [4, 5]])); // [[1, 5]]
console.log(solution([[1,3],[0,3],[4,5]])); // []
console.log(solution([[1, 3]])); // [[1, 3]]