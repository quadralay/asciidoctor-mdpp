<!-- #mdp-includes -->
## File Includes

A File Include statement points to another Markdown++ file and imports the file's contents at the location of the statement. This enables multi-file structure in a single document.

<!--style:BQ_Learn-->
> ### Syntax
> 
> An Include statement is created by writing a path to a Markdown++ document between `<!--include:` and `-->`. Relative paths and absolute paths are both valid path values. Web paths are not supported. The include statement must be the only thing on a line.
> 
> #### Basics
> 
> A basic Include statement. The Include must be written on it's own line to work properly.
> ```
> <!--include:my_file.md-->
> ```
> 
> Relative paths and absolute paths are fine to use.
> ```
> <!--include:my_file.md-->
> ```
> 
> ```
> <!--include:C:/Users/Me/Docs/my_file.md-->
> ```
> 
> Multiple includes can be used in the same document.
> ```
> <!--include:my_file.md-->
> 
> <!--include:doc_2.md-->
> ```

### File Includes Behavior

When ePublisher detects a File Include statement, the file is read, and the Include tag is replaced with the content of the file. If the no file is found at the path given, the Include tag will be passed through to the output as an HTML Comment.

#### Using a File Include

To use an Include statement, all that needs to be done is write the tag where the file's content is to be imported. Below, an include statement is written below a Title.

```
Learning ePublisher
===================

<!--include:epublisher_basics.md-->

```

This can even be done inside of documents used in an Include statement, as long as it is not a [Recursive Include][mdp-includes-recursion]. Use this feature to create Map Files for many Markdown++ documents, or create documents needed for content re-use.

<!--#mdp-includes-recursion-->
#### Recursive Includes

If an Include statement tries to insert a document that has already been inserted by a parent file, ePublisher's generation log will display a message like this one:

```
[Warning]  
Skipping recursive include file:  
 'C:\Users\Me\Documents\include_doc.md'  
 in file: 'C:\Users\Me\main_doc.md'
```

This message displays because ePublisher cannot insert the document. Doing so would create a recursive loop and would break the generation. If this message is recieved, it's time to look at the layout of Includes in the source documents.

The message can be useful to track down the file in error. The first file path refers to the file in the attempted Include statement. The second file path refers to where the Include occured.
