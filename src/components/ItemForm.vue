<template>
    <form @submit="onSubmit" class="item-form">
        <!-- 국가 -->
        <div class="form-control">
            <label>국가</label>
            <select name="nation_cd" id="nation_cd" v-model="nation_cd" placeholder="국가">
                <option :key="country.nation_cd" v-for="country in itemform_data.countries" :value="country.nation_cd">{{ country.nation_nm }}</option>
            </select>
        </div>
        <!-- 카테고리 -->
        <div class="form-control">
            <label>카테고리</label>
            <select name="cat_mst_cd" id="cat_mst_cd" v-model="cat_mst_cd" v-on:change="whenChangedCatMst">
                <option :key="mst.cat_mst_cd" v-for="mst in itemform_data.cat_mst" :value="mst.cat_mst_cd">{{ mst.cat_mst_nm }}</option>
            </select>
            <select name="cat_dtl_cd" id="cat_dtl_cd" v-model="cat_dtl_cd">
                <option :key="dtl.cat_dtl_cd" v-for="dtl in current_cat_dtl" :value="dtl.cat_dtl_cd">{{ dtl.cat_dtl_nm }}</option>
            </select>
        </div>
        <!-- 품목명 -->
        <div class="form-control">
            <label>품목명</label>
            <input type="text" name="item_nm" v-model="item_nm" placeholder="품목명">
        </div>
        <!-- 제조사 -->
        <div class="form-control">
            <label>제조사명</label>
            <input type="text" name="company_nm" v-model="company_nm" placeholder="제조사명">
        </div>
        <!-- 수입국 -->
        <div class="form-control">
            <label>수입국</label>
            <select name="imported_from" id="imported_from" v-model="imported_from" placeholder="수입국">
                <option :key="country.nation_cd" v-for="country in itemform_data.countries" :value="country.nation_cd">{{ country.nation_nm }}</option>
            </select>
        </div>
        <!-- 수량 -->
        <div class="form-control">
            <label>수량</label>
            <input type="number" name="quantity" v-model="quantity" min="1">
        </div>
        <!-- 수입금지 여부 -->
        <div class="form-control form-control-check">
            <label>수입금지 여부</label>
            <input type="checkbox" name="is_banned" v-model="is_banned">
        </div>

        <!-- 저장하기 -->
        <input type="submit" value="저장" class="btn btn-block">
    </form>
</template>

<script>
export default {
    name: 'ItemForm',
    data() {
        return {
            itemform_data: {
                countries: [],
                cat_mst: [],
                cat_dtl: []
            },
            current_cat_dtl: [],
            // form 데이터
            nation_cd: '',
            cat_mst_cd: '',
            cat_dtl_cd: '',
            item_nm: '',
            company_nm: '',
            imported_from: '',
            quantity: 1,
            is_banned: false
        }
    },
    async created() {
        // 국가코드 불러오기
        this.itemform_data.countries = await this.fetchData(`countries`, {
            method: 'GET',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json'
            }
        })

        // 기본 카테고리 불러오기
        this.itemform_data.cat_mst = await this.fetchData(`category/master`, {
            method: 'GET',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json'
            }
        })

        // 상세 카테고리 불러오기
        this.itemform_data.cat_dtl = await this.fetchData(`category/detail`, {
            method: 'GET',
            mode: 'cors',
            headers: {
                'Content-Type': 'application/json'
            }
        })
    },
    methods: {
        async fetchData(url_path, options) {
            const res = await fetch(`${process.env.VUE_APP_API_URL}${url_path}`, options)
            const response = await res.json()
            if (!response.ok) {
                console.log(`[${url_path}] 데이터 연동 실패...\n${response.message}\n`)
            }
            return response.data || null
        },
        whenChangedCatMst() {
            this.cat_dtl_cd = ''
            this.current_cat_dtl = this.itemform_data.cat_dtl.filter((item, index, array) => {
                return item.cat_mst_cd === this.cat_mst_cd
            })
        },
        checkForm() {
            this.item_nm = this.item_nm.trim()
            this.company_nm = this.company_nm.trim()

            if (!this.nation_cd) {
                alert("국가를 선택해주세요.")
                return false
            }
            if (!this.cat_mst_cd) {
                alert("기본 카테고리를 선택해주세요.")
                return false
            }
            if (!this.cat_dtl_cd) {
                alert("상세 카테고리를 선택해주세요.")
                return false
            }
            if (!this.item_nm) {
                alert("품목명을 입력해주세요.")
                return false
            }
            if (this.item_nm.search(/['"`]/) > -1) {
                alert("품목명에는 따옴표 (\',\",\`)를 입력할 수 없습니다!")
                return false
            }
            if (!this.company_nm) {
                alert("제조사명을 입력해주세요.")
                return false
            }
            if (this.company_nm.search(/['"`]/) > -1) {
                alert("품목명에는 따옴표 (\',\",\`)를 입력할 수 없습니다!")
                return false
            }
            if (!this.imported_from) {
                alert("수입 국가를 선택해주세요.")
                return false
            }
            if (!this.quantity && this.quantity <= 0) {
                alert("품목은 1개 이상 입력해야 합니다.")
                return false;
            }

            return true
        },
        resetForm() {
            this.current_cat_dtl = []
            this.nation_cd = ''
            this.cat_mst_cd = ''
            this.cat_dtl_cd = ''
            this.item_nm = ''
            this.company_nm = ''
            this.imported_from = ''
            this.quantity = 1
            this.is_banned = false
        },
        onSubmit(e) {
            e.preventDefault()
            if (!this.checkForm()) {
                return
            }
            const newItem = {
                nation_cd: this.nation_cd,
                cat_mst_cd: this.cat_mst_cd,
                cat_dtl_cd: this.cat_dtl_cd,
                item_nm: this.item_nm,
                company_nm: this.company_nm,
                imported_from: this.imported_from,
                quantity: this.quantity,
                is_banned: this.is_banned
            }
            
            this.$emit('add-item', newItem)
            this.$nextTick(() => {
                this.resetForm()
            })
        }
    },
    emits: ['add-item'],
}
</script>

<style scoped>
.item-form {
    margin-bottom: 40px;
}

.form-control {
    margin: 20px 0px;
}

.form-control label {
    display: block;
    font-weight: bold;
}

.form-control input {
    width: 100%;
    height: 40px;
    margin: 5px;
    padding: 3px 7px;
    font-size: 17px;
}

.form-control select {
    width: 70%;
    height: 40px;
    margin: 5px;
    padding: 3px 7px;
    font-size: 17px;
}

.form-control-check {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.form-control-check label {
    flex: 1;
}

.form-control-check input {
    flex: 2;
    height: 20px;
}
</style>