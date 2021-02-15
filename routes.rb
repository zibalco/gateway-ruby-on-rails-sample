Rails.application.routes.draw do

    get 'zibal' => 'zibal#pay'
    match '/pay-zibal' => 'zibal#pay', via: :post
    match '/pay-zibal' => 'zibal#pay', via: :get
    match 'zibal-callback', to: 'zibal#verify', via: [:get]
  
  end