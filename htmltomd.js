const fs = require('fs')
const rowDelimiter = '|--|--|--|--|'
let markdown = ['# Code Coverage']

const content = processHtmlDir('coverage/')

fs.writeFileSync('markdowntest.md', content)

function processHtmlDir(path) {
    let ignoreDirs = [
        '.css',
        '.js',
        '.fonts'
    ]

    let ignoreFiles = [
        'dashboard.html'
    ]

    let files = fs.readdirSync(path)

    files.forEach(function (file) {
        if (file == 'index.html') {
            // TODO: Get the directory total when in an index file
            //markdown = markdown.concat(getDirTotal(fs.readFileSync(`${path}/${file}`).toString()))
        } else if (fs.statSync(`${path}/${file}`).isDirectory()) {
            if (!ignoreDirs.includes(file)) {
                markdown.push(`# ${file}`)
                markdown.push('| Label | Lines | Functions and Methods | Classes and Traits |')
                markdown.push(rowDelimiter)
                processHtmlDir(`${path}/${file}`)
            }

            return
        } else if (!ignoreFiles.includes(file)) {
            markdown.push(`## ${file}`)
            markdown.push('| Label | Classes and Traits | Functions and Methods | Lines |')
            markdown.push(rowDelimiter)

            markdown = markdown.concat(processHtmlContent(fs.readFileSync(`${path}/${file}`).toString()))
        }
    })

    return markdown.join('\n')
}

function processHtmlContent(content) {
    processedContent = [];

    const tableBody = content.match(/<tbody>.+?<\/tbody>/gs)[0];
    const rows = [...tableBody.matchAll(/<tr>.+?<\/tr>/gs)]

    const labelRegex = /<td.+?>(?:&nbsp;<a.+?><abbr.+?>)?(?<label>.+?)<(?:\/abbr><\/a><\/td>|\/td>)\s*<td.+?>\s*<div.+?>.+?<\/td>/s
    const rowRegex = /<td.+?>\s*<\/td>\s*<td.+?><div.+?>(?<percentage>[\d\.]+%)<\/div><\/td>\s*<td.+?>\s*<div.+?>(?<covered>\d+)(?:(?:&nbsp;)|\s)\/(?:(?:&nbsp;)|\s)(?<noncovered>\d+)<\/div>\s*<\/td>/gs
    rows.forEach(function (row) {
        let column = []

        row = row[0].replace(/<\/?tr>/g, '')
        label = row.match(labelRegex)[1]
        column.push(`| ${label}`)

        let parts = [...row.matchAll(rowRegex)]

        parts.forEach(function (part, i, arr) {
            let percentage = part[1].trim()
            let covered = part[2].trim()
            let noncovered = part[3].trim()

            let roundPercentage = percentage.match(/^\d{1,3}/gm)[0]
            let urlImage = `![](https://progress-bar.dev/${roundPercentage})`

            column.push(`| ${urlImage} :: ${covered}/${noncovered} ${i == arr.length - 1 ? '|' : ''}`)
        })

        if (column.length > 1) {
            processedContent.push(column.join(' '))
        }
    });

    return processedContent.join(`\n`)
}
