//
//  CloudKitHelpers.swift
//  TMShared
//
//  Created by Travis Ma on 6/25/16.
//  Copyright © 2016 Travis Ma. All rights reserved.
//

import UIKit
import CloudKit

func referencesToRecordNames(references: CKRecordValue?) -> String {
    var recordNames = [String]()
    if let refs = references as? [CKRecord.Reference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames.joined(separator: ",")
}

func referencesToRecordNamesArray(references: CKRecordValue?) -> [String] {
    var recordNames = [String]()
    if let refs = references as? [CKRecord.Reference] {
        for r in refs {
            recordNames.append(r.recordID.recordName)
        }
    }
    return recordNames
}

func recordToData(record: CKRecord) -> NSData {
    let archivedData = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: archivedData)
    archiver.requiresSecureCoding = true
    record.encodeSystemFields(with: archiver)
    archiver.finishEncoding()
    return archivedData
}

func dataToRecord(data: NSData) -> CKRecord? {
    let unarchiver = NSKeyedUnarchiver(forReadingWith: data as Data)
    unarchiver.requiresSecureCoding = true
    return CKRecord(coder: unarchiver)
}

func showCKError(currentViewController: UIViewController, error: Error) {
    var errorMessage = error.localizedDescription
    if let error = error as? CKError {
        switch error.code {
        case .serverRecordChanged, .changeTokenExpired:
            errorMessage = "Looks like the data on your device is too old to update. Please do a refresh and try again."
        default:
            break
        }
    }
    DispatchQueue.main.async(execute:{
        let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        currentViewController.present(alert, animated: true, completion: nil)
    })
}

func nullCheckInt(_ int: CKRecordValue?) -> Int {
    if let int = int as? Int {
        return int
    } else {
        return 0
    }
}

func nullCheckString(_ string: CKRecordValue?) -> String {
    if let s = string as? String {
        return s.trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
        return ""
    }
}
