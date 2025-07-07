# Contacts App (iOS)

An iOS app built with Swift and UIKit that displays a list of contacts. Users can view contacts in either a list (UITableView) or grid (UICollectionView) layout, add new contacts, delete existing ones, and dynamically manage grouped sections. Both layouts stay synchronized with all changes.


---



## Features

- Toggle between list and grid layouts
- Add new contacts (grouped by first letter)
  - If no section exists for the letter, a new one is created
- Delete contacts:
  - Swipe to delete in list mode
  - Long press + confirmation in grid mode
  - If the last contact in a section is deleted, the section is removed
- Expand/collapse sections in the list view
- Full synchronization between list and grid layouts:
  - Any change (add/delete) in one layout reflects in the other

---

## Technologies Used

- Swift
- UIKit
- UITableView
- UICollectionView
- UIAlertController
- UILongPressGestureRecognizer

---
