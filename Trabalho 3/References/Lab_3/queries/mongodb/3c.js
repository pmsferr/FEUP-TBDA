db.facilities.aggregate([
{
     $unwind: "$MUNICIPALITIES"
},
{
     $match: {"MUNICIPALITIES.ACTIVITIES.ACTIVITY": { $ne: 'cinema' }}
},
{
    $group: {count: { $sum: 1 },_id: 0}
},
{
	$project: {_id: 0}
}
])