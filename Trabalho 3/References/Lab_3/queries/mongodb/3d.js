db.facilities.aggregate([
{
     $unwind: "$MUNICIPALITIES"
},
{
     $unwind: "$MUNICIPALITIES.ACTIVITIES"
},
{
     $unwind: "$MUNICIPALITIES.ACTIVITIES.FACILITIES"
},
{
     $group: {
           _id : {designation:"$MUNICIPALITIES.DESIGNATION",
             	  activity:"$MUNICIPALITIES.ACTIVITIES.ACTIVITY"},
           count: { $sum: 1 }
           }
},
{
  	$sort: {
  	  		count: -1
  		   }
},
{
     $group: {
               _id : "$_id.activity",
               Designation : { $first: '$_id.designation' },
               Max_value : {$max: "$count"}
             }
},
{
  	$sort: {
  	  		_id: 1
  		   }
}
])