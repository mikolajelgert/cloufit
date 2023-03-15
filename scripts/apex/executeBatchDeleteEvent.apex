// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

BatchDeleteEvent batchJob = new BatchDeleteEvent();

Id batchJobId = Database.executeBatch(batchJob, 200);

AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors
                    FROM AsyncApexJob WHERE ID =: batchJobId ];
System.debug('Job Id: ' + batchJobid + ' Status: ' + aaj.Status);