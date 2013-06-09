module.exports = {
  mongo_url: process.env.MONGOHQ_URL || 'mongodb://localhost:27017/gtfs',
  agencies: [
    /* Put agency_key names from gtfs-data-exchange.com.
    Optionally, specify a download URL to use a dataset not from gtfs-data-exchange.com */
    'nyct', { agency_key: 'nyct', url: 'http://www.mta.info/developers/data/nyct/subway/google_transit.zip'}
  ]
};