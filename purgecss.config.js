module.exports = {
    safelist: {
        // Exact class names to always keep
        standard: ['start', 'previously', 'table-of-contents', 'with-table-of-contents', 'beside-float', 'p-with-image'],
        // Keep classes matching these patterns
        greedy: [/^start/, /previously/, /table-of-contents/, /with-table-of-contents/]
    }
}
