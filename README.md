#MagicAct

An ActionKit extension for data analysis, visualization, ETL, and advanced payment processing!

*Note: Visualization and QuickDonate tools are still sitting in another Ruby repo that isn't ready to be released, they will be ported into this repo by January 1st 2015.*

##Setup

Setup is relatively easy. You'll need to:

1. Clone this repo.
2. Install the accompanying [SalesForce Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04to0000000Bv9L)
3. Create a SalesForce Connected App to get a Client ID and Client Secret (Go to Setup>Create>Apps>Connected Apps>New)
4. Create an API-only ActionKit user (Optional but recommended)
5. Create an AWS Bucket in which to hold ETL result records (optional)
6. Create a new .env using .sample_env as a template 
7. Launch on Heroku!

##How ETL Works in MagicAct

MagicAct takes an Extract, Transform, Load approach to the issue of connecting SalesForce to ActionKit.

###Object Rules
 ActionKit database tables are mapped onto SalesForce Objects (SObjects or Custom Objects) by Object Rules. Each Object Rule can map one or more ActionKit tables onto exactly one SalesForce Object. So for instance, the table core_user is mapped onto an custom AKID__c object by default (see setup to install this object into your SF instance).

###Field Rules
 
  Object Rules are composed of Field Rules. Field Rules map a particular ActionKit database field onto a particular SalesForce Object Field. So, for instance, the ActionKit field core_transaction.total is mapped onto Opportunity.Amount in SalesForce.
  
###Advanced Field Rules

  Field rules are used directly in the queries passed to ActionKit. This has two implications:

1. Jobs can fail if Field Rules have typos in them
2. Extract Fields can contain more than just a single field.

For instance, the following are all valid Extract Field values:

`core_user.last_name`
    
`if( core_user.zip, concat_ws( '-', core_user.zip, if( length( core_user.plus4 ), core_user.plus4, null ) ), core_user.postal )`
    
`( select coalesce( group_concat( phone order by core_phone.id desc separator ', ' ), '' ) from core_phone where core_phone.user_id = core_user.id )`

To make a long story short, if it works in MySQL, it will work as an extract field value.

On the Field Rules Page of your Object Rule you will see what fields you have available to query.

###Primary and Foreign Key Fields

  Each Object Rule has two special field rules, one marked as a Primary Field, and one marked as a Foreign Key Field. The Primary Field marks the Field to be used as a primary key by the SalesForce Bulk Uploader tool. Often this will be table.id, but it might not always be (for instance, you might choose to use core_transaction.transaction_id instead of core_transaction.id, although I wouldn't recommend it due to recurring donation complications).

 Foreign Key Fields reflect which field rule represents the id of the primary object (user) this object is associated with. Almost always, this will be the field rule which represents the user ID or AKID.

##Transformations

  Transformations are just Ruby functions which will be used to process the extracted values before loading them into SalesForce. Inside of transformations, the extracted value can be referenced using the variable **value**. So, if you wanted to make sure that the extracted value was entirely in lowercase you could use
  
    downcase(value) 
  
  as your Transformation. Or if you wanted to translate from "True" or "False" into 1 or 0 respectively, you could use:
  
    value == "True" ? 1 : 0
  
  
  *Please Note: Transformations are not done in a separate environment (yet). I would like to implement this in the future but for right now they are run in the same runtime and with the same authority as the rest of the job, so errors in your transformations will cause jobs to fail. For your own peace of mind, transformations should be limited to things like simple if and switch statements.*
 
 
##Primary Object

  By default, the primary object is a user. I don't see any reason why you would need to change this behavior so I won't go into too much detail. Basically, the Primary Object must be queried and loaded first. Think about it this way: If you try to upload all of your donations without first loading in your donors, your data will be useless. Every record you load in (e.g. petitions, donations, event attendance, letter sending) must be associated with a user. Because of that, we mark our user as our primary object (by default), and make sure that all of our users who have relevant data are correctly loaded into SalesForce before we upload their related activites.