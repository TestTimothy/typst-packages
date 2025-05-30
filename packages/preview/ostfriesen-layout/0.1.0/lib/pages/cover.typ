#import "../translations.typ": translations

#let create-cover-page(
  title: none,
  authors: (),
  matriculation-numbers: (),
  date: none,
  document-type: none,
  faculty: none,
  module: none,
  course-of-studies: none,
  supervisor1: none,
  supervisor2: none,
  supervisor3: none,
  company: none,
  company-supervisor: none,
  lang: "en"
) = {
  // Localization
  let t = translations.at(if lang in translations.keys() { lang } else { "en" })
  
  // Set the document's basic properties for the first page
  set page(
    margin: (left: 0mm, right: 0mm, top: 0mm, bottom: 0mm),
    numbering: none,
    number-align: center,
  )

  // University Logo
  place(
    top + right,
    dx: -13mm,
    dy: 10mm,
    image("../logo.svg", width: 164pt)
  )

  // Title etc.
  pad(
    left: 57mm,
    top: 66mm,
    right: 18mm,
    stack(
      // Document Type
      if document-type != none {
        upper(text(document-type, size: 9pt, weight: "bold"))
        v(3mm)
      },

      // Authors
      {
        let formatted-authors = if authors.len() == 0 { 
          "" 
        } else if authors.len() == 1 { 
          authors.at(0) 
        } else { 
          authors.join(", ", last: " & ") 
        }
        text(formatted-authors, size: 10pt)
      },

      v(13mm),
      // Title
      par(
        leading: 9pt,
        justify: false,
        text(title, size: 31pt, weight: 500, font: "New Computer Modern"),
      ),
      v(5mm),
      line(start: (0pt, 0pt), length: 30pt, stroke: 1mm),
      v(10mm),
      //module
      if module != none {
        text(t.at("cover-module"), size: 10pt, weight: "bold")
        v(-2mm)
        text(module, size: 10pt)
      },
      
    )
  )

  // University name text
  place(
    right + bottom,
    dx: -11mm,
    dy: -35mm,
    box(
      align(
        left,
        stack(
          line(start: (0pt, 0pt), length: 25pt, stroke: 0.9mm),
          v(3mm),
          text("HOCHSCHULE EMDEN/LEER", size: 9pt, weight: "bold", font: "Open Sans"),
          v(2mm),
          text("University of Applied Sciences Emden/Leer", size: 9pt, font: "Open Sans")
        )
      )
    )
  )

  // Second cover page
  pagebreak()

  // Set the document's basic properties for the second page
  set page(
    margin: (left: 31.5mm, right: 32mm, top: 55mm, bottom: 67mm),
    numbering: none,
    number-align: center,
  )

  // Title section at the top
  stack(
    // Authors
    align(
      center,
      {
        let formatted-authors = if authors.len() == 0 { 
          "" 
        } else if authors.len() == 1 { 
          authors.at(0) 
        } else { 
          authors.join(", ", last: " & ") 
        }
        text(formatted-authors, size: 14pt, font: "New Computer Modern")
      },
    ),
    v(23mm),
    // Title
    align(
      center,
      par(
        leading: 13pt,
        justify: false,
        text(title, size: 18pt, font: "New Computer Modern"),
      ),
    ),
  )

  // The main content of the second page needs to be placed
  // with fixed positions to ensure consistent layout
  let page-height = 297mm - 55mm - 67mm // A4 height minus top and bottom margins
  
  // Now we build the page using place() to position key elements

  if date != none {
    place(
      bottom,
      dy: 30mm,
      stack(
        line(start: (0pt, 0pt), length: 25pt, stroke: 1mm),
        v(4mm),
        text(t.at("submitted") + ": " + if type(date) == datetime { 
            date.display("[day]. [month repr:long] [year]")
          } else {
            date
          },
          size: 10pt,
        )
      )
    )
  }
  
  // Step 2: Place the matriculation numbers section
  {
    // Limit the number of authors to 10
    let display-authors = if authors.len() > 10 {
      authors.slice(0, 10)
    } else {
      authors
    }
    
    // Use consistent spacing of 19mm for all cases
    let mat-numbers-pos = 19mm
    
    if matriculation-numbers.len() > 0 or display-authors.len() > 0 {
      place(
        bottom,
        dy: mat-numbers-pos,
        stack(
          line(start: (0pt, 0pt), length: 25pt, stroke: 1mm),
          v(4mm),
          
          // Use grid layout for all cases - with different column config based on author count
          {
            // Define consistent author entry styling
            let author-entry(author, has-matnum, matnum) = {
              if has-matnum {
                text(author + ": " + t.at("matriculation-number") + " " + matnum, size: 10pt)
              } else {
                text(author, size: 10pt)
              }
            }
            
            if display-authors.len() > 5 {
              // Two column layout for more than 5 authors
              grid(
                columns: 2,
                gutter: 10mm,
                // Left column (first 5 authors)
                stack(
                  ..display-authors.slice(0, 5).enumerate().map(((i, author)) => {
                    stack(
                      author-entry(
                        author, 
                        i < matriculation-numbers.len(), 
                        if i < matriculation-numbers.len() { matriculation-numbers.at(i) } else { "" }
                      ),
                      if i < 4 { v(3mm) }
                    )
                  })
                ),
                // Right column (remaining authors)
                align(top,
                stack(
                  ..display-authors.slice(5).enumerate().map(((i, author)) => {
                    // Calculate actual index in the full list
                    let actual-i = i + 5
                    stack(
                      author-entry(
                        author, 
                        actual-i < matriculation-numbers.len(), 
                        if actual-i < matriculation-numbers.len() { matriculation-numbers.at(actual-i) } else { "" }
                      ),
                      if i < display-authors.slice(5).len() - 1 { v(3mm) }
                    )
                  })
                ))
              )
            } else {
              // Single column grid for 5 or fewer authors
              grid(
                columns: 1,
                // Use the exact same stack structure as the two-column case
                stack(
                  ..display-authors.enumerate().map(((i, author)) => {
                    stack(
                      author-entry(
                        author, 
                        i < matriculation-numbers.len(), 
                        if i < matriculation-numbers.len() { matriculation-numbers.at(i) } else { "" }
                      ),
                      if i < display-authors.len() - 1 { v(3mm) }
                    )
                  })
                )
              )
            }
          }
        )
      )
    }
  }
  
  // Step 3: Place the supervision section
  {
    // Use a consistent position for the supervision section
    let supervision-pos = -14mm  
    // Adjust position based on number of authors - move down when fewer authors
    let adjusted-pos = if authors.len() < 5 {
      supervision-pos - ((5 - authors.len()) * -5.5mm)
    } else {
      supervision-pos
    }
    place(
      bottom,
      dy: adjusted-pos,
      stack(
        line(start: (0pt, 0pt), length: 25pt, stroke: 1mm),
        v(4mm),
        if supervisor1 != none {
          text(t.at("first-supervisor") + ": " + text(upper(supervisor1), weight: "bold"), size: 10pt)
        },
        if supervisor2 != none {
          v(2mm)
          text(t.at("second-supervisor") + ": " + text(upper(supervisor2), weight: "bold"), size: 10pt)
        },
        if supervisor3 != none {
          v(2mm)
          text(t.at("third-supervisor") + ": " + text(upper(supervisor3), weight: "bold"), size: 10pt)
        },
        if company != none {
          v(2mm)
          text(t.at("company") + ": " + text(upper(company), weight: "bold"), size: 10pt)
        },
        if company-supervisor != none {
          v(2mm)
          text(t.at("company-supervisor") + ": " + text(upper(company-supervisor), weight: "bold"), size: 10pt)
        }
      )
    )
  }
  
  // Step 4: Place the document type and university info
  {
    // Count the number of supervisor entries present
    let supervisor-count = (
      (if supervisor1 != none { 1 } else { 0 }) +
      (if supervisor2 != none { 1 } else { 0 }) +
      (if supervisor3 != none { 1 } else { 0 }) +
      (if company != none { 1 } else { 0 }) +
      (if company-supervisor != none { 1 } else { 0 })
    )
    
    // Base position
    let base-content-pos = -44mm
    
    // Adjust for fewer than 5 authors - similar to supervision section
    let author-adjustment = if authors.len() < 5 {
      ((5 - authors.len()) * 5mm)  // Match the supervisor adjustment
    } else {
      0mm
    }
    
    // Adjust for fewer supervisor entries (if any supervisors are present)
    let supervisor-adjustment = if supervisor-count > 0 {
      // Assuming max of 5 supervisors, adjust by 3mm for each missing one
      ((5 - supervisor-count) * 5mm)
    } else {
      0mm  // No adjustment needed if no supervisors
    }
    
    // Calculate final position
    let content-pos = if supervisor1 != none or supervisor2 != none or supervisor3 != none or company != none or company-supervisor != none {
      // If supervisors exist, adjust based on author count and supervisor count
      base-content-pos + author-adjustment + supervisor-adjustment
    } else if matriculation-numbers.len() > 0 or authors.len() > 0 {
      // If no supervisors but authors exist, use a different position
      -45mm + author-adjustment
    } else if date != none {
      // If only date exists
      -45mm
    } else {
      // Fallback
      -25mm
    }
    
    place(
      bottom,
      dy: content-pos,
      {
        // Create an array of content items that are present
        let content-items = ()
        
        // Add the document type
        content-items.push(if document-type != none {
          text(document-type + " " + t.at("submitted-for-examination"))
        } else {
          text(t.at("thesis-submitted-for-examination"))
        })
        
        // Add module if present
        if module != none {
          content-items.push(text(t.at("in-the-module") + " " + text(module, style: "italic")))
        }
        
        // Add course of studies if present
        if course-of-studies != none {
          content-items.push(text(t.at("of-the-study-course") + " " + text(course-of-studies, style: "italic")))
        }
        
        // Add faculty if present
        if faculty != none {
          content-items.push(text(t.at("at-the-faculty-of") + " " + text(faculty, style: "italic")))
        }
        
        // Always add the university name
        content-items.push(text(t.at("at-university")))
        
        // Create a stack with the content items, separated by appropriate spacing
        stack(
          spacing: 3mm,
          ..content-items
        )
      }
    )
  }
}