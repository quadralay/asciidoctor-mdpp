<!-- #mdp-multiline-tables -->
## Multiline Tables in Markdown++

Multiline tables in Markdown++ provide an enhanced way to organize detailed content across multiple lines, allowing for more readable and flexible structures. Unlike standard tables, multiline tables allow rows to span multiple lines by using a special tag and structured spacing.

### Introduction

Multiline tables are very similar to regular Markdown tables, but they are more flexible when it comes to the table structure. In Markdown++, multiline tables are indicated by placing a `<!-- multiline -->` tag directly above the table. Additionally, a new row is created by adding a row of cells that are either empty or contain only whitespace.

A key feature of multiline tables is that you can include full block Markdown elements within cells, such as lists, code blocks, or paragraphs. This makes multiline tables particularly useful when content within a cell becomes too detailed to fit conveniently on a single line. By utilizing multiline tables, writers can keep content organized and easier to edit.

<!--style:BQ_Learn-->
> ### Syntax
>
> Multiline tables in Markdown++ consist of the same main elements as standard tables:
>
> - A **header row**, which contains header cell content separated by `|` characters.
> - An **alignment row**, which indicates the alignment of the body cells' text. Each cell in this row contains at least 3 `-` characters, and an optional `:` character to indicate alignment. Each cell is separated by a `|` character.
>   - Default alignment only uses `-` characters; 3 or more.
>   - Left align the column by starting the cell with `:` and filling in the rest with `:` characters; 3 or more.
>   - Right align the column by starting the cell with 3 or more `-` characters, ending with a `:` character.
>   - Center align the column by starting and ending the cell with `:` characters. Put `-` characters between them; 3 or more.
> - 1 or more **body rows**, that contain body cell content separated by `|` characters.
>
> The key difference is the `<!-- multiline -->` tag and the ability to use blank rows to create new table rows, along with the capability to write full block Markdown inside cells.
>
> #### Multiline Tag
>
> To use a multiline table, add the following tag directly above your table:
> ```
> <!-- multiline -->
> ```
> This tag tells Markdown++ to treat the following table as a multiline table.
>
> #### Creating New Rows
>
> To create a new row, simply add a row of cells that are either empty or contain only whitespace. This indicates to Markdown++ that the next line of cells should be treated as part of a new row.
>
> #### Basics
>
> Below is an example of a multiline table:
> ```
> <!-- multiline -->
> | name | details                   |
> |------|--------------------------|
> | Bob  | Lives in Dallas.         |
> |      | - Enjoys cycling         |
> |      | - Loves cooking          |
> |      |                          |
> | Mary | Lives in El Paso.        |
> |      | - Works as a teacher     |
> |      | - Likes painting         |
> ```
>
> In this example, the empty row acts as a separator, creating a break before the next row. Notice how detailed information, including lists, is included within a cell.
>
> You can also use multiline tables without wrapping `|` characters:
> ```
> <!-- multiline -->
>  name | details
> ------|--------------------------
>  Bob  | Lives in Dallas.
>       | - Enjoys cycling
>       | - Loves cooking
>       |
>  Mary | Lives in El Paso.
>       | - Works as a teacher
>       | - Likes painting
> ```
>
> #### Alignment in Multiline Tables
>
> Just like with standard tables, multiline tables can have different alignments for each column.
>
> Left-align the text of cells in a column by starting the alignment cell with `:`:
> ```
> <!-- multiline -->
> | name | details                  |
> |:-----|-------------------------|
> | Bob  | Lives in Dallas.        |
> |      | - Enjoys cycling        |
> |      | - Loves cooking         |
> |      |                         |
> | Mary | Lives in El Paso.       |
> |      | - Works as a teacher    |
> |      | - Likes painting        |
> ```
>
> Center-align the text of cells in a column by starting and ending the alignment cell with `:`:
> ```
> <!-- multiline -->
> |  name  | details                 |
> |:------:|-------------------------|
> |  Bob   | Lives in Dallas.        |
> |        | - Enjoys cycling        |
> |        | - Loves cooking         |
> |        |                         |
> |  Mary  | Lives in El Paso.       |
> |        | - Works as a teacher    |
> |        | - Likes painting        |
> ```
>
> ##### Markdown In Multiline Tables
>
> Multiline tables can also include full Markdown blocks, such as code blocks or lists:
> ```
> <!-- multiline -->
> | name     | hobbies                 |
> |----------|-------------------------|
> | **Bob**  | - Biking                |
> |          | - Cooking               |
> |          | - Reading               |
> |          |                         |
> | **Mary** | Here is a code example: |
> |          |                         |
> |          | ```                     |
> |          | function greet() {      |
> |          |     console.log("Hi");  |
> |          | }                       |
> |          | ```                     |
> ```
>
> Including full Markdown blocks like code and lists helps emphasize complex content within cells, making tables more versatile.
>
> #### Markdown++ Custom Styles
>
> A custom Table Style can be given to a multiline Table using a Markdown++ style tag directly above the multiline tag. Additionally, multiple Markdown++ commands can be combined using `;`:
> ```
> <!--style:CustomTable; multiline -->
> | name | description                  |
> |------|-----------------------------|
> | Bob  | - Loves biking              |
> |      | - Enjoys programming        |
> |      |                             |
> | Mary | A passionate teacher.       |
> |      | - Loves painting            |
> |      | - Enjoys hiking             |
> ```
>
> ##### Content in Cells
>
> Inline text content can be further customized using the inline tag convention, and multiple commands can be used in a single tag:
> ```
> <!-- multiline -->
> | name                          | age | city    |
> |-------------------------------|-----|---------|
> | <!--style:CustomText-->*Bob*  | 42  | Dallas  |
> |                               |     |         |
> | <!--style:CustomText-->*Mary* | 37  | El Paso |
> ```
>
> To learn more about Markdown++ tagging, see [Learning Markdown++][mdp-learning-mdp].

### ePublisher Style Information

#### Style Behavior

In order to style a multiline Table and its cells in detail, the same styles are needed as with standard tables in ePublisher. A multiline table gets 3 styles when detected in a document: **Table**, **Table Cell Head**, and **Table Cell Body**.

##### Table Style

The Table Style is the primary style that ePublisher adds when a multiline table is detected. The default name is **Table**, but this can be customized using a Markdown++ style tag.

###### Customizing the Table Style

By adding a Markdown++ custom style tag, the Table Style name can be changed:

```
<!--style:CustomTable; multiline -->
| name | age | city    |
|------|-----|---------|
| Bob  | 42  | Dallas  |
|      |     |         |
| Mary | 37  | El Paso |
```

##### Header & Body Cell Styles

Header and body cell styles function in the same way for multiline tables as they do for standard tables. Each header cell gets a **Table Cell Head** style, and each body cell gets a **Table Cell Body** style. These styles can also be customized if the Table Style is given a custom name:

```
<!--style:CustomTable; multiline -->
| name | age | city    |
|------|-----|---------|
| Bob  | 42  | Dallas  |
|      |     |         |
| Mary | 37  | El Paso |
```

#### Default Style Properties

Style Type: **Table**, **Paragraph**
Style Name: **Table**, **Table Cell Head**, **Table Cell Body**

##### Table

 Property | Value
----------|-------
 border top color | #222222
 border top style | solid
 border top width | 1px
 border right color | #222222
 border right style | solid
 border right width | 1px
 border bottom color | #222222
 border bottom style | solid
 border bottom width | 1px
 border left color | #222222
 border left style | solid
 border left width | 1px

##### Table Cell Head

 Property | Value
----------|-------
 font family | Arial
 font size | 11pt
 font weight | bold
 padding top | 6pt
 padding right | 6pt
 padding bottom | 6pt
 padding left | 6pt

##### Table Cell Body

 Property | Value
----------|-------
 font family | Arial
 font size | 11pt
 padding top | 6pt
 padding right | 6pt
 padding bottom | 6pt
 padding left | 6pt

If a custom style name is assigned to a multiline Table, the style names will still inherit all of the listed default style information.