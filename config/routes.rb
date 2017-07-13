Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/constituencies/:constituency_id', to: 'constituencies#show', as: 'constituency'
  get '/constituencies/:constituency_id/map', to: 'constituencies#map', as: 'constituency_map'
  get '/constituencies/lookup', to: 'constituencies#lookup'
  post '/constituencies/postcode_lookup', to: 'constituencies#postcode_lookup'

  get '/people/:person_id', to: 'people#show', as: 'person'
  get '/people/lookup', to: 'people#lookup'
  post '/people/postcode_lookup', to: 'people#postcode_lookup'

  get '/contact_points/:contact_point_id', to: 'contact_points#show'

  get '/houses/:house_id', to: 'houses#show', as: 'house'
  get '/houses/:house_id/parties/:party_id', to: 'houses/parties#show'
  get '/houses/lookup', to: 'houses#lookup'

  get '/parliaments/:parliament_id', to: 'parliaments#show', as: 'parliament'
  get '/parliaments/:parliament_id/next', to: 'parliaments#next_parliament'
  get '/parliaments/:parliament_id/previous', to: 'parliaments#previous_parliament'
  get '/parliaments/next', to: 'parliaments#next'
  get '/parliaments/previous', to: 'parliaments#previous'
  get '/parliaments/current', to: 'parliaments#current'
  get '/parliaments/lookup', to: 'parliaments#lookup'
  get '/parliaments/:parliament_id/parties/:party_id', to: 'parliaments/parties#show'
  get '/parliaments/:parliament_id/houses/:house_id', to: 'parliaments/houses#show'
  get '/parliaments/:parliament_id/houses/:house_id/parties/:party_id', to: 'parliaments/houses/parties#show'

  get '/parties/:party_id', to: 'parties#show'
  get '/parties/lookup', to: 'parties#lookup'

  # External urls

  get '/constituencies/current', to: redirect('http://localhost:3030/constituencies/current'), as: 'constituencies_current'
  get '/constituencies/current/a-z/:letter', to: redirect('http://localhost:3030/constituencies/current/a-z/:letter'), as: 'constituencies_current_a_z_letter'

  get '/houses/:house_id/members/current/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/members/current/a-z/:letter'), as: 'house_members_current_a_z_letter'
  get '/houses/:house_id/members/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/members/a-z/:letter'), as: 'house_members_a_z_letter'
  get '/houses/:house_id/parties/current', to: redirect('http://localhost:3030/houses/:house_id/parties/current'), as: 'house_parties_current'
  get '/houses/:house_id/parties/:party_id/members/current/a-z/:letter', to: redirect('http://localhost:3030/houses/:house_id/parties/:party_id/members/current/a-z/:letter'), as: 'house_parties_party_members_current_a_z_letter'
  get '/houses/:house_id/parties/:party_id/members', to: redirect('http://localhost:3030/houses/:house_id/parties/:party_id/members'), as: 'house_parties_party_members'

  get '/mps', to: redirect('http://localhost:3030/mps'), as: 'mps'

  get '/parties/:party_id', to: redirect('http://localhost:3030/parties/:party_id'), as: 'party'
  get '/parties/:party_id/members/current', to: redirect('http://localhost:3030/parties/:party_id/members/current'), as: 'party_members_current'
  get '/parties/:party_id/members', to: redirect('http://localhost:3030/parties/:party_id/members'), as: 'party_members'

  get '/parliaments', to: redirect('http://localhost:3030/parliaments'), as: 'parliaments'
  get '/parliaments/:parliament_id/members', to: redirect('http://localhost:3030/parliaments/:parliament_id/members'), as: 'parliament_members'
  get '/parliaments/:parliament_id/parties', to: redirect('http://localhost:3030/parliaments/:parliament_id/parties'), as: 'parliament_parties'
  get '/parliaments/:parliament_id/constituencies', to: redirect('http://localhost:3030/parliaments/:parliament_id/constituencies'), as: 'parliament_constituencies'
  get '/parliaments/:parliament_id/parties/:party_id/members', to: redirect('http://localhost:3030/parliaments/:parliament_id/parties/:party_id/members'), as: 'parliament_party_members'
  get '/parliaments/:parliament_id/houses/:house_id/members', to: redirect('http://localhost:3030/parliaments/:parliament_id/houses/:house_id/members'), as: 'parliament_house_members'
  get '/parliaments/:parliament_id/houses/:house_id/parties', to: redirect('http://localhost:3030/parliaments/:parliament_id/houses/:house_id/parties'), as: 'parliament_house_parties'
  get '/parliaments/:parliament_id/houses/:house_id/parties/:party_id/members', to: redirect('http://localhost:3030/parliaments/:parliament_id/houses/:house_id/parties/:party_id/members'), as: 'parliament_house_party_members'
end
