require 'net/http'
require 'json'
require 'httparty'

class ZibalController < ApplicationController
    # Author : Yahya Kangi #
	# WebSite : http://zibal.ir #
	# Version : 1.0 #
	def pay
		if !params['amount'].blank?
			if params['amount'].to_i > 99

				response = HTTParty.post("https://gateway.zibal.ir/v1/request".to_str, 
					:body => { 
								"merchant" => 'zibal', 
								"callbackUrl" => 'http://localhost/zibal-callback', 
								"amount" => params['amount'], 
								"description" => 'my ruby app', 
							}.to_json,
					:headers => { 'Content-Type' => 'application/json' } )

				response_body = response.body
				response_json = JSON.parse(response_body)
				result = response_json["result"]
				
				if result.to_i != 100
					render :text => "خطا در تراکنش"
				else 
					trackId = response_json["trackId"]
					session[:AMOUNT] = params['amount'] # ذخیره ی موقف مبلغ در سشن
					redirect_to "https://gateway.zibal.ir/start/#{trackId}"
				end
			else
				render :text => "مبلغ نا معتبر است"
			end
		else
			render :text => "مبلغ را وارد کنید"
		end
	end
	def verify

		if !params['trackId'].blank?

			response = HTTParty.post("https://gateway.zibal.ir/v1/verify".to_str, 
				:body => { 
							"merchant" => 'zibal', 
							"trackId" => params['trackId'],
						}.to_json,
				:headers => { 'Content-Type' => 'application/json' } )

			response_body = response.body
			response_json = JSON.parse(response_body)
			result = response_json["result"]

			session.delete(:AMOUNT)
			status = params['status']
			trackId = params['trackId']
			# ref_number = response_json['refNumber'] // Not sent in sandbox mode
			if result == 100
				render :text => "تراکنش با موفقیت انجام شد . کد پیگیری : #{trackId}"
			else 
				render :text => "تراکنش از طرف کاربر متوقف شد"
			end
		else
			redirect_to "http://localhost/zibal/"
		end
	end
end
