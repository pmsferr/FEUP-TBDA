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
	$match: {"MUNICIPALITIES.REGION": "Algarve",
	  		 "MUNICIPALITIES.ACTIVITIES.ACTIVITY": "cinema" }
},
{
	$group: {_id: "$MUNICIPALITIES.DESIGNATION",
			 facilities: { $push: "$MUNICIPALITIES.ACTIVITIES.FACILITIES"}}
},
{
	$sort: {_id: 1}
}
])